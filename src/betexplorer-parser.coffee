###
 * Betexplorer Parser
###
request		= require('request')
cheerio		= require('cheerio')
team			= require('./team')
game			= require('./game')

Immutable	= require('./immutable')

q = null
trim = (str) ->
	str.replace(/(?:(?:^|\n)\s+|\s+(?:$|\n))/g,'').replace(/\s+/g,' ')

class BetexplorerLeagueDataParser extends Immutable
	constructor: (args) ->
		@[k] = v for k, v of @_buildProperties(['path', 'beginYear'], args)
	
	url: -> "http://www.betaexplorer.com/soccer/" + @path() + "/results"
	
	parse: ->
		defer = q.defer()
		games = []
		request @url(), (err, resp, body) =>
			$ = cheerio.load(body)
			index = {}
			for r in $('#leagueresults_tbody tr')
				teamStr = trim($(res).text()) for res in $(r).find('.first-cell.tl a')
				continue if !teamStr
				continue if teamStr of index
				index[teamStr] = 1
				teams = []
				teams.push(team(t)) for t in teamStr.split(/\s-\s/)
				[hT, aT] = teams
				[h, a] = trim($(res).text()).split(/:/) for res in $(r).find('.result a')
				[d, m, y] = trim($(res).text()).split(/\./) for res in $(r).find('.date')
				date = new Date(y, m-1, d)
				games.push(game(date, hT, aT, h, a))
			defer.resolve(games)
		defer.promise
	
module.exports = 
	EN1_2013: (qService)->
		q = qService;
		new BetexplorerLeagueDataParser({path: 'england/premier-league-2013-2014', beginYear: 2013})
