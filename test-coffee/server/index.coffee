###
 * New coffeescript file
###
football = require('../../lib/server/index')

exports.indexTest =
	"hmmm": (test) ->
		football.getData('EN1', 2014).then (data) ->
				test.done()
			,(error) -> console.log("there was an erro getting football data.")
