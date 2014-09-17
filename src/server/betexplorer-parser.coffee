###
 * Betexplorer Parser
###

define ['request', 'q', 'cheerio', 'game', 'team', 'immutable'], (request, q, cheerio, game, team, Immutable) ->
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
					games.push(game.newGame(date, hT, aT, h, a))
				defer.resolve(games)
			defer.promise
		
	
	EN1_2013: () ->
		new BetexplorerLeagueDataParser({path: 'england/premier-league-2013-2014', beginYear: 2013})
