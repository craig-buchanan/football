index = require('../lib/index')

exports.indexTest = 
	"something": (test) ->
		test.equal("Test", index.obj)
		test.done()
