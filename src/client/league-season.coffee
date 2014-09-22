`if (typeof define !== 'function') { var define = (require('amdefine'))(module); }`

define ['./immutable', './game'], (Immutable, game) ->
	dataLoader = null
	q = null

	class Standing extends Immutable
		constructor: (args) ->

			@[k] = v for k, v of @_buildProperties ['team', 'season', 'fixtures'], args

			[gamesPlayed, wins, draws, losses, points, goals, against, position, weighting] = [null, null,null,null,null,null,null,null,null]

			@games 	= () -> if gamesPlayed?then gamesPlayed else ( @fixtures().filter (g)-> g.played()).length
			@wins		= () -> if wins? then wins else wins = (@fixtures().filter (g)=> g.winner() == @team()).length
			@losses	= () -> if losses? then losses else losses = (@fixtures().filter (g)=> g.winner() == g.opponent(@team())).length
			@draws	= () -> if draws? then draws else draws = (@fixtures().filter (g)=> g.played() and g.winner() == null).length
			@points	= () ->
				return points if points?
				points = points + g.teamPoints(@team()) for g in @fixtures()
				points
			@goals	= () ->
				return goals if goals != null
				goals = goals + g.teamGoals(@team()) for g in @fixtures()
				goals
			@against	= () ->
				return against if against != null
				against = against + g.teamGoals(g.opponent(@team())) for g in @fixtures()
				against
			@diff = () -> @goals() - @against()
			@weighting = ()->
				return weighting if weighting != null
				weighting = @points() * 1000 + @diff() + goals / 1000

	class LeagueSeason extends Immutable
		constructor: (args) ->
			@[k] = v for k, v of @_buildProperties(['league', 'beginYear'], args)

			[games, teams, teamsIndex, teamGames, teamStandings] = [null, [], {},{}, {}]

			addTeamStanding = (game) ->
				for t in [game.homeTeam(), game.awayTeam()]
					teams.push t if !(t.hashcode() of teamsIndex)
					teamsIndex[t.hashcode()] = t
					teamGames[t.hashcode()] = [] if !teamGames[t.hashcode()]
					teamGames[t.hashcode()].push game
					teamStandings[t.hashcode()] = [] if !teamStandings[t.hashcode()]
					teamStandings[t.hashcode()].push new Standing({team: t, season: this, fixtures: teamGames[t.hashcode()]})

			@games = ()->
				defer = q.defer()
				if games != null
					defer.resolve games
				else
					dataLoader.getSeasonGames( @league().key(), @beginYear()).then (gameDataList) ->
							games =  gameDataList.map (gd)-> game.deserialize(gd)
							addTeamStanding g for g in games
							teams.sort (a, b) -> if a.name() < b.name() then -1 else 1
							defer.resolve games

						, (err) -> defer.reject err
				defer.promise

			@teams = () ->
				defer = q.defer()
				if !teams? or teams.length == 0
					@games().then (gms) ->
						defer.resolve teams
				else
					defer.resolve teams
				defer.promise

			@standings = (gameNumber) ->
				defer = q.defer()
				@teams().then (teams)->
					ret = []
					for t in teams
						standings = teamStandings[t.hashcode()]
						if(!gameNumber)
							ret.push standings[standings.length-1]
						else
							ret.push if gameNumber > standings.length then standings[standings.length-1] else standings[gameNumber-1]
					ret.sort (a, b) -> b.weighting() - a.weighting() or if a.team().name() < b.team().name() then -1 else 1
					ret[x].position = parseInt(x) + 1 for x, v of ret
					defer.resolve ret
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