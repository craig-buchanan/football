###
 * New coffeescript file
###
requirejs = require 'requirejs'
requirejs.config
	baseUrl: 'lib',
	paths: {
		'cliserv': 'client',
		'squirejs': '../node_modules/squirejs/src/Squire'
	}
	nodeRequire: require
Squire = requirejs 'squirejs'
q = require('q')
injector = new Squire()
serialized_game_data = '[{"date":"2014-08-16T11:45:00.000Z","homeTeam":{"name":"Manchester Utd","_type":"Team"},"awayTeam":{"name":"Swansea City","_type":"Team"},"home":"1","away":"2","_type":"Game"},{"date":"2014-08-16T14:00:00.000Z","homeTeam":{"name":"Leicester City","_type":"Team"},"awayTeam":{"name":"Everton","_type":"Team"},"home":"2","away":"2","_type":"Game"}]'
mock_http = (@conf) ->
mock_http.get = (url) ->
	defer = q.defer()
	setTimeout(()-> 
		defer.resolve(serialized_game_data)
	, 1)
	defer.promise
	

module.exports.ClientGameDataLoader =
	setUp: (done) ->
		done()
	tearDown: (done) ->
		done()

	"test that it makes a well formed http request": (test) ->
		test.done()