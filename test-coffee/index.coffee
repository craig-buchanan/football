###
 * New coffeescript file
###
football = require('../lib/index')

exports.indexTest = 
	"hmmm": (test) ->
		football.getData('EN1', 2014).then (data) ->
			test.done();
