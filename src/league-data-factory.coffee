###
 * New coffeescript file
###
#game		= require('./game')(require('./injector'))
#league	= require('./league')
#fs			= require('fs')
#config	= require('config')
#json		= require('json-serialize')
#q				= require('q')

define [ ], () ->
	loadGamesFromFile = (league, year) ->
		defer = q.defer()
		fileName = config.Football.data_store + "/" + league.key() + "_" + year
		fs.readFile fileName, (err, data)->
			throw err if err
			gamesData = JSON.parse(data)
			games = []
			games.push(game.deserialize(g)) for g in gamesData
			defer.resolve(games)
		return defer.promise
		
	class LeagueDataFactory
		constructor: () ->
			
		getData: (league, year) ->
			loadGamesFromFile(league, year)

			
	getDataFactory: () ->
		new LeagueDataFactory()