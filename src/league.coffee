###
 * Football league
###

Immutable = if typeof module != 'undefined' && module.exports then require('./immutable') else this.Immutable

leagueDataLoader = null
class LeagueSeason extends Immutable
	constructor: (args) ->
		@[k] = v for k, v of @_buildProperties(['league', 'beginYear'], args)

class League extends Immutable
	constructor: (args) ->
		@[k] = v for k, v of @_buildProperties(['name', 'key', 'beginYear'], args)

LEAGUES = 
	factory: (injector) ->
		[leagueDataLoader, Immutable] = [injector.leagueDataLoader(), injector.immutable()]
		'EN1': new League({'key': 'EN1', 'beginYear': '1998', 'name': 'Premier League'})


if typeof module != 'undefined' && module.exports then module.exports = LEAGUES else this.NODE_FOOTBALL_LEAGUES = LEAGUES
		
	