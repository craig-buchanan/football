requirejs = require('requirejs')
requirejs.config
	baseUrl: __dirname + "/..",
	nodeRequire: require

q = requirejs('q')
module.exports = 
	getData: (league, year) ->
		defer = q.defer()
		requirejs ['server/game-data-loader'], (gdl) ->
			gdl(league, year).then (data) ->
				defer.resolve data
		return defer.promise

