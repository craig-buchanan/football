###
 * Betexplorer Parser
###
request 	= require('request')
q 				= require('q')
cheerio 	= require('cheerio')

game 			= require('../client/game')
team 			= require('../client/team')
Immutable = require('../client/immutable')

trim = (str) ->
	str.replace(/(?:(?:^|\n)\s+|\s+(?:$|\n))/g,'').replace(/\s+/g,' ')

class BetexplorerLeagueDataParser extends Immutable
	constructor: (args) ->
		@[k] = v for k, v of @_buildProperties(['path', 'beginYear'], args)

	url: -> "http://www.betexplorer.com/soccer/" + @path() + "/results"

	parse: ->
		defer = q.defer()
		games = []
		request @url(), (err, resp, body) =>

			return defer.reject(err) if err
			$ = cheerio.load(body)
			index = {}
			results = $('#leagueresults_tbody tr')
			return defer.reject "no results found in:" + body unless results
			for r in results

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

				games.push(game.newGame(date, hT, aT, h, a))
			return defer.reject "We did not find any games" if games.length == 0
			defer.resolve(games)
		defer.promise

keyMap =
	'EN1': 'england/premier-league-'
	'EN2': 'england/championship-'
	'EN3': 'england/league-one-'
	'EN4': 'england/league-two-'
	'DE1': 'germany/bundesliga-'
	'DE2': 'germany/2-bundesliga-'

module.exports = (key, beginYear)->
	new BetexplorerLeagueDataParser({path: keyMap[key] + beginYear + '-' + (beginYear+1), 'beginYear': beginYear}).parse()
