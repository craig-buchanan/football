###
 * server side game-data-loader test
###
config = require 'config'
fs = require 'fs'
requirejs = require 'requirejs'

requirejs.config
	baseUrl: 'lib',
	paths:
		'cliserv': 'server'
	nodeRequire: require
console.log process.env.NODE_ENV
data_loader = requirejs('cliserv/game-data-loader')

module.exports.gameDataLoaderTest = 
	"test loads season": (test) ->
		test.expect(1)
		data_loader('EN1', 2014).then (data) ->
			console.log "data has been returned"  
			games = JSON.parse(data)
			test.equals games.length, 380
			test.done() 
		, (err) -> console.log "Data loader threw an error: " + err
	"test reads from remote site when data not there": (test) ->
		filename = config.football.data_store + "/EN1_2013.json";
		fs.unlink(filename, () ->)
		data_loader('EN1', 2012).then (data) ->
			test.done()
		
