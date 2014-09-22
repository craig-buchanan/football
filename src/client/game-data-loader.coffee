`if (typeof define !== 'function') { var define = (require('amdefine'))(module); }`

define ['module'], (module) ->

	baseUrl = module.config().gameDataUrl
	class GameDataLoader
		constructor: (http, q) ->
			@getSeasonGames = (leagueKey, year) ->
				defer = q.defer()
				http.get(baseUrl + "/#{leagueKey}/#{year}").then (response) ->
					defer.resolve response.data
				defer.promise
