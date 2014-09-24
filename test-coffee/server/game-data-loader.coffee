###
 * server side game-data-loader test
###
mockery			= require 'mockery'
q						= require 'q'


[be_mock, ss_mock, config_mock, fs_mock, data_loader] = [null, null, null, null, null]

base_setup = () ->
	mockery.enable(useCleanCache:true)
	mockery.registerAllowables(['q', 'path', 'util', './team', './game', '../../lib/server/game-data-loader']);

	[config_mock, fs_mock] = [{}, {}]
	mockery.registerMock('config', config_mock)
	mockery.registerMock('fs', fs_mock)
	config_mock.football =
		data_store: "TESTYPOO"

base_tearDown = (callback) ->
	mockery.deregisterMock('fs');
	mockery.deregisterMock('config');
	mockery.deregisterMock('./betexplorer-parser');
	mockery.deregisterMock('./soccerstats-parser');
	mockery.disable()
	data_loader = null
	callback()

module.exports.gameDataLoader =
	setUp: (callback) ->
		base_setup()
		mockery.registerMock('./betexplorer-parser', {})
		mockery.registerMock('./soccerstats-parser', {})

		callback()

	tearDown: (callback) ->
		base_tearDown(callback)

	"getSeasonGames attempts to read game data file and returns content if there": (test) ->

		[leagueKey, year, fileReadError] = ['EN1', 2010, null]
		fileData = JSON.stringify({success: true})

		fs_mock.readFile = (fileName, callback) ->
			test.equal fileName, config_mock.football.data_store + "/" + leagueKey + "_" + year + ".json"
			callback(fileReadError, fileData)

		data_loader = require('../../lib/server/game-data-loader')
		data_loader.getSeasonGames(leagueKey, year).then (data) ->
			test.ok(data.success)
			test.done()

module.exports.gameDataLoaderBetExplorerCalls =
	setUp: (callback) ->
		base_setup()

		fs_mock.readFile = (f, callback) -> callback(true)
		mockery.registerMock('./soccerstats-parser', {})
		callback()

	tearDown: (callback) ->
		base_tearDown(callback)

	"getSeasonGames calls bet explorer parser when data file is absent and league is older and writes result to file": (test) ->
		[leagueKey, year] = ['EN1', 2010]
		parser_data = {success: true}

		fs_mock.writeFile = (fileName, data, callback) ->
			test.equal(JSON.stringify(parser_data), data, "The data passed to writefile is not correct")
			test.equal fileName, config_mock.football.data_store + "/" + leagueKey + "_" + year + ".json", "The filename passed to write file is incorrect"
			callback()

		be_mock = (key, yr) ->
			def = q.defer()
			test.equal key, leagueKey
			test.equal year, yr
			def.resolve parser_data
			def.promise

		mockery.registerMock('./betexplorer-parser', be_mock)
		data_loader = require('../../lib/server/game-data-loader')

		data_loader.getSeasonGames(leagueKey, year).then (data) ->
			test.ok(JSON.parse(data).success)
			test.done()

	"getSeasonGames gives error when failing to write file": (test) ->
		be_mock = () ->
			def = q.defer()
			def.resolve {test: 'data'}
			def.promise
		mockery.registerMock('./betexplorer-parser', be_mock)

		fs_mock.writeFile = (fileName, data, callback) ->
			callback(true)

		data_loader = require('../../lib/server/game-data-loader')
		data_loader.getSeasonGames('key', 2010).then(
			()->
				null
			,(err) ->
				test.ok err
				test.done()
		)

	"getSeasonGames gives an error when there is an error in the betexplorer parser": (test) ->
		be_mock = () ->
			def = q.defer()
			def.reject "error"
			def.promise
		mockery.registerMock('./betexplorer-parser', be_mock)
		data_loader = require('../../lib/server/game-data-loader')
		data_loader.getSeasonGames('key', 2010).then null ,(err) ->
			test.ok(err)
			test.done()

module.exports.gameDataLoaderSoccerStatsCalls =
	setUp: (callback) ->
		base_setup()
		fs_mock.readFile = (f, callback) -> callback(true)
		mockery.registerMock('./betexplorer-parser', {})
		callback()

	tearDown: (callback) ->
		base_tearDown(callback)


	"getSeasonGames calls soccerstats parser when it is the current seasson": (test) ->
		[leagueKey, year] = ['EN1', new Date().getFullYear()]
		ss_mock = (lk, y) ->
			defer = q.defer()
			test.equal lk, leagueKey, "the key passed to the soccerstats parser should be: '" + leagueKey + "' but is: '" + lk + "'"
			test.equal y, year, "the year passed to the soccerstats parser should be: '" + year + "' but is: '" + y + "'"
			test.done()
			defer.resolve "{'data': 'ok'}"
			defer.promise
		mockery.registerMock('./soccerstats-parser', ss_mock)

		data_loader = require('../../lib/server/game-data-loader')
		data_loader.getSeasonGames(leagueKey, year)

	"getSeasonGames gives error when soccerstats parser give error": (test) ->
		ss_mock = (lk, y) ->
			defer = q.defer()
			defer.reject "error"
			defer.promise
		mockery.registerMock('./soccerstats-parser', ss_mock)

		data_loader = require('../../lib/server/game-data-loader')
		data_loader.getSeasonGames("Blah", new Date().getFullYear()).then null, (err)->
			test.ok(err)
			test.done()

