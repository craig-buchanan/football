###
 * Football league
###
define ['./immutable', ], (Immutable) ->
	leagueDataLoader = null
	class LeagueSeason extends Immutable
		constructor: (args) ->
			@[k]	= v for k, v of @_buildProperties(['league', 'beginYear'], args)
	
	class League extends Immutable
		constructor: (args) ->
			@[k] = v for k, v of @_buildProperties(['name', 'key', 'beginYear'], args)
	
	LEAGUES = 
		factory: () ->
			'EN1': new League('key': 'EN1', 'beginYear': '1998', 'name': 'Premier League')
	