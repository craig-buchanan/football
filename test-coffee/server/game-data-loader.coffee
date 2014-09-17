###
 * server side game-data-loader test
###
requirejs = require 'requirejs'
requirejs.config
	baseUrl: 'lib',
	paths:
		'cliserv': 'server'
		'data': '../data'
	text:
		env: 'node'
	nodeRequire: require
console.log process.env.NODE_ENV
data_loader = requirejs('cliserv/game-data-loader')

module.exports.gameDataLoaderTest = 
	"test loads season": (test) ->
		test.expect(2)
		data_loader('EN1', 2014).then (games) -> 
			test.equals games.length, 380
			test.equals games[0].homeTeam().name(), "Manchester Utd"
			test.done() 
		
			
