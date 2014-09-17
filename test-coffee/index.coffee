###
 * New coffeescript file
###
football = require('../lib/index')
console.log(football)

exports.indexTest = 
	"hmmm": (test) ->
		football.getData('EN1', 2014).then (data) ->
			console.log data
			test.done();
