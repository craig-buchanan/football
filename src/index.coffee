#parser = require('./soccerstats-parser')
#q = require('q')
#league = require('./game')

#l = new league({beginYear: 2014})
#console.log("league begin year should be 2014 and is: " + l.beginYear())
#if l.league()? then console.log("league year is correctly undefined") else console.log("league year is defined")

requirejs = require('requirejs')
requirejs.config
	baseUrl: __dirname,
	nodeRequire: require

module.exports = 
	getData: (league, year) ->
		require ['server/game-data-loader'], (gdl)->
			gdl(league, year)

