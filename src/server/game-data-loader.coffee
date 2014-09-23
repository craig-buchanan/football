###
 * New coffeescript file
###

config		= require('config')
fs 				= require('fs')
q  				= require('q')
path 			= require('path')

be_parser = require('./betexplorer-parser')
ss_parser	= require('./soccerstats-parser')

writeDataFile = (games, fileName, defer) ->
	data = JSON.stringify(games)
	fs.writeFile fileName, data, (err) ->
		return defer.reject(err) if err
		defer.resolve data


dataFromSrc = (key, year, fileName) ->
	defer = q.defer()
	if(year < 2014)
		be_parser(key,year).then (games) ->
				writeDataFile( games, fileName, defer)
			, (err) ->
				return defer.reject "We did not get the result we wanted from the Betex parser: " + err

	else
		ss_parser(key, 2014).then (games) ->
				writeDataFile games, fileName, defer
			,(err) ->
				defer.reject "The soccerstats parser gave an error: " + err
	defer.promise

class GameDataLoader
	constructor: ->
	getSeasonGames: (key, year) ->
		defer = q.defer()
		fileName = path.join config.football.data_store, key + "_" + year + ".json"
		fs.readFile fileName, (err, data)->
			if err
				dataFromSrc(key, year, fileName).then (games) ->
						defer.resolve(games)
					, (err)->
						defer.reject err
			else defer.resolve JSON.parse(data.toString())
		defer.promise


module.exports = new GameDataLoader()

