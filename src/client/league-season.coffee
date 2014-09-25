`if (typeof define !== 'function') { var define = (require('amdefine'))(module); }`

define ['./immutable', './game'], (Immutable, game) ->
	dataLoader = null
	q = null

	class Standing extends Immutable
		constructor: (args) ->

			@[k] = v for k, v of @_buildProperties ['team', 'season', 'fixtures'], args

			[gamesPlayed, wins, draws, losses, points, goals, against, position, weighting] = [null, null,null,null,null,null,null,null,null]

			@games 	= () => if gamesPlayed?then gamesPlayed else ( @fixtures().filter (g)-> g.played()).length
			@wins		= () => if wins? then wins else wins = (@fixtures().filter (g)=> g.winner() == @team()).length
			@losses	= () => if losses? then losses else losses = (@fixtures().filter (g)=> g.winner() == g.opponent(@team())).length
			@draws	= () => if draws? then draws else draws = (@fixtures().filter (g)=> g.played() and g.winner() == null).length

			@points	= () =>
				return points if points?
				points = points + g.teamPoints(@team()) for g in @fixtures()
				points

			@goals	= () =>
				return goals if goals != null
				goals = goals + g.teamGoals(@team()) for g in @fixtures()
				goals

			@against	= () =>

				return against if against != null
				against = against + g.teamGoals(g.opponent(@team())) for g in @fixtures()
				against

			@diff = () => @goals() - @against()

			@weighting = ()->

				return weighting if weighting != null
				weighting = @points() * 1000 + @diff() + goals / 1000

			@game = () => @fixtures()[@fixtures().length-1]


			@setPosition = (pos) -> position = pos
			@position = () -> position

	class LeagueSeason extends Immutable

		constructor: (args) ->
			@[k] = v for k, v of @_buildProperties(['league', 'beginYear'], args)

			[gamesDefer] = [null]
			[games, teams, teamsIndex, teamGames, teamStandings, tables] = [null, [], {},{}, {}, []]

			addTeamStanding = (game) =>
				for t in [game.homeTeam(), game.awayTeam()]
					teams.push t if !(t.hashcode() of teamsIndex)
					teamsIndex[t.hashcode()] = t
					teamGames[t.hashcode()] = [] if !teamGames[t.hashcode()]
					teamGames[t.hashcode()].push game
					teamStandings[t.hashcode()] = [] if !teamStandings[t.hashcode()]
					teamStandings[t.hashcode()].push new Standing({team: t, season: @, fixtures: teamGames[t.hashcode()].map (g)-> g})

			sortTables = ()->
				for x in [0..((teams.length-1)*2-1)] by 1
					tables[x] = []
					tables[x].push teamStandings[t.hashcode()][x] for t in teams
					tables[x].sort (a, b) -> b.weighting() - a.weighting() or if a.team().name() < b.team().name() then -1 else 1
					standing.setPosition(index+1) for standing, index in tables[x]

			@games = ()->

				if(games?)
					defer = q.defer()
					defer.resolve games
					return defer.promise

				if gamesDefer?
					return gamesDefer.promise
				else
					gamesDefer = q.defer()

				dataLoader.getSeasonGames( @league().key(), @beginYear()).then (gameDataList) ->
						games =  gameDataList.map (gd)-> game.deserialize(gd)
						games.sort (a, b) -> a.date().getTime() - b.date().getTime() or if a.homeTeam().name() < b.homeTeam().name() then -1 else 1

						addTeamStanding g for g in games
						sortTables()
						teams.sort (a, b) -> if a.name() < b.name() then -1 else 1

						gamesDefer.resolve games

					, (err) -> gamesDefer.reject err
				gamesDefer.promise

			@teams = () ->
				defer = q.defer()

				@games().then (gms) ->
					defer.resolve teams

				defer.promise

			[standingsResolved] = [false]
			@standings = (gameNumber) ->
				defer = q.defer()
				@teams().then (teams)->
					gameNumber = tables.length if !gameNumber? or gameNumber > tables.length
					defer.resolve tables[gameNumber-1]
				defer.promise

			@standingsForTeam = (team, gameDay) ->
				defer = q.defer()
				@standings().then (standings)->

					defer.resolve teamStandings[team.hashcode()]
				defer.promise

			@gamesForTeam = (team) ->
				defer = q.defer()
				@teams().then (teams) ->
					defer.resolve teamGames[team.hashcode()]
				defer.promise

	(dLoader, qService) ->
		dataLoader = dLoader;
		q = qService
		LeagueSeason