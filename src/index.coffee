parser = require('./soccerstats-parser')
q = require('q')



parser.EN_2014(q).then (games) -> 
	console.log( g.toString() ) for g in games



