###
 * Betexplorer Parser
###
request 	= require('request')
cheerio 	= require('cheerio')
timezone 	= require('timezone')

tz 			= timezone(require("timezone/Europe"))
teams		= require('./team')
game		= require('./game')

q = null
class BetexplorerLeagueDataParser
	constructor: (@path, @beginYear, @zone) ->
		