betexplorer = require ("../../lib/server/betexplorer-parser")

module.exports.BetExplorerParserTest =
	"test that import is a function": (test)->
		test.equals(typeof betexplorer, "function")
		test.done()