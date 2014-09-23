
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
			season = leaguesList[0].getSeason(year)
			if !season?
				defer.reject "'" + leaguesList[0].name() + "' has no season data available for year: " + year
			else
				season.games().then (games) ->
						defer.resolve JSON.stringify(games)
					, (err) -> defer.reject err
		defer.promise




