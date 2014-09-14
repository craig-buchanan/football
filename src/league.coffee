###
 * Football league
###
config	= require('config')
fs			= require('fs')


Immutable = require('./immutable')

LEAGUES = {
}

_serializeToFile = (fileName, games) ->
	
class LeagueDataFactory 
	constructor: ->
	
	getSeason: (leagueKey, beginYear) ->
		fileName = leagueKey + "_" + beginYear
		console.log(config.get("Football.data_store"))
		
	 
class LeagueSeason extends Immutable
	constructor: (args) ->
		@[k] = v for k, v of @_buildProperties(['league', 'beginYear'], args)

class League extends Immutable
	constructor: (args) ->
		@[k] = v for k, v of @_buildProperties(['name', 'key', 'beginYear'], args)

#module.exports = LeagueDataFactory
$NODE_CONFIG_DIR = "./config"
new LeagueDataFactory().getSeason('EN1', 2014)