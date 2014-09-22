
dataLoader = {}
q = require('q')

leagues = require('../../lib/client/league')(dataLoader, q)

module.exports.LeagueTest =
	"Test construction": (test) ->
		test.equals(leagues[0].beginYear(), 1998)
		test.done()

	"Test Season Creation": (test) ->
		seasons = leagues[0].seasons()
		test.equals(seasons.length, 17)
		test.done()
