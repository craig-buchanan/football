#parser = require('./soccerstats-parser')
#q = require('q')
#league = require('./game')

#l = new league({beginYear: 2014})
#console.log("league begin year should be 2014 and is: " + l.beginYear())
#if l.league()? then console.log("league year is correctly undefined") else console.log("league year is defined")


#parser.EN3_2014(q).then (games) -> 
#	games.sort((a, b) -> a.date.getTime() - b.date.getTime() or if a.homeTeam.name < b.homeTeam.name then -1 else 1) 
#	console.log( g.toString() ) for g in games
#	console.log("There are " + games.length + " games"); 
requirejs = require('requirejs')
requirejs.config
	baseUrl: __dirname,
	nodeRequire: require

module.exports = 
	getData: (league, year) ->
		requirejs('server/game-data-loader')(league, year)

