###
 * New coffeescript file
###
cheerio = require('cheerio')
fs 			= require('fs')
q				= require('q')

mockery = require('mockery')
mockery.registerAllowable('cheerio')
mockery.registerAllowable('./immutable')
mockery.registerAllowable('./game')
mockery.registerAllowable('./team')
mockery.registerAllowable('../lib/betexplorer-parser')
mockery.registerAllowable('util')

reqMock = () ->
	console.log("bl")
mockery.registerMock 'request', 
	(url, callback) ->
		fs.readFile "index.html", 'utf8', (err, data) -> 
			callback(err, 200, data)


mockery.enable()

betexparser = require('../lib/betexplorer-parser')
exports.BetexTest =
	"request stub functions": (test) ->
		#test.expect(1)
		#betex = betexparser.EN1_2013(q)
		#betex.parse().then (games) ->
		#	console.log((index+1) + ". " + game) for game,index in games
		#	test.equal(games.length, 380)
		test.done()
		
		

mockery.disable()