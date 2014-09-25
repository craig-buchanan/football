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

			[gamesLoading] = [false]
			[games, teams, teamsIndex, teamGames, teamStandings, tables] = [null, [], {},{}, {}, []]

			addStandingCount = 0;
			addTeamStanding = (game) =>

				for t in [game.homeTeam(), game.awayTeam()]
					teams.push t if !(t.hashcode() of teamsIndex)
					teamsIndex[t.hashcode()] = t
					teamGames[t.hashcode()] = [] if !teamGames[t.hashcode()]
					teamGames[t.hashcode()].push game
					teamStandings[t.hashcode()] = [] if !teamStandings[t.hashcode()]

					gamesForTeam = teamGames[t.hashcode()][0..teamGames[t.hashcode()].length]

					teamStandings[t.hashcode()].push new Standing({team: t, season: @, fixtures: gamesForTeam})


			sortTables = ()->
				for x in [0..((teams.length-1)*2-1)] by 1
					tables[x] = []
					for t in teams
						tables[x].push teamStandings[t.hashcode()][x]
						console.log "team #{t.name()} has no standing for gameday: #{x+1}" if !teamStandings[t.hashcode()][x]

					tables[x].sort (a, b) -> b.weighting() - a.weighting() or if a.team().name() < b.team().name() then -1 else 1
					if tables[x]
						for std, index in tables[x]
							if std
								std.setPosition(index+1)
							else
								console.log("We have a problem on game day: " + (x+1) )


			@games = ()->

				if(games?)
					defer1 = q.defer()
					defer1.resolve games
					return defer1.promise

				if gamesLoading
					defer2 = q.defer()
					setTimeout((()=> @games().then (gs) -> defer2.resolve gs), 5)
					return defer2.promise
				gamesLoading = true
				defer = q.defer()

				dataLoader.getSeasonGames( @league().key(), @beginYear()).then ((gameDataList) ->
						games =  gameDataList.map (gd)-> game.deserialize(gd)
						games.sort (a, b) -> a.date().getTime() - b.date().getTime() or if a.homeTeam().name() < b.homeTeam().name() then -1 else 1
						addTeamStanding g for g in games
						teams.sort (a, b) -> if a.name() < b.name() then -1 else 1
						sortTables()
						defer.resolve games
					), (err) -> defer.reject err
				defer.promise

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