
gdl 		= require('./game-data-loader')
q 			= require('q')
leagues = require('../client/league')

module.exports = 
	getData: (leagueKey, year) ->

		defer = q.defer()
		leaguesList = leagues(gdl, q).filter (l) -> l.key() == leagueKey
		if leaguesList.length == 0
			defer.reject "League '" + leagueKey + "' is unknown"
		else
			gdl.getSeasonGames(leaguesList[0].key(), year).then (games)->
				defer.resolve games
		defer.promise




