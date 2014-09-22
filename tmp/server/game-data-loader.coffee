###
 * server side game-data-loader test
###
config = require 'config'
fs = require 'fs'
requirejs = require 'requirejs'

requirejs.config
	baseUrl: 'lib',
	nodeRequire: require
data_loader = requirejs('./server/game-data-loader')

module.exports.gameDataLoaderTest = 
	"test loads season": (test) ->
		test.expect(1)
		data_loader('EN1', 2014).then (data) ->
			games = JSON.parse(data)
			test.equals games.length, 380
			test.done() 
		, (err) -> console.log "Data loader threw an error: " + err
	"test reads from remote site when data not there": (test) ->
		filename = config.football.data_store + "/EN1_2013.json";
		fs.unlink(filename, () ->)
		data_loader('EN1', 2013).then (data) ->
			test.done()
		
