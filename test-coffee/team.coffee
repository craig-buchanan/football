###
 * New coffeescript file
###
requirejs = require('requirejs')
requirejs.config
	baseUrl: 'lib',
	nodeRequire: require

team = requirejs("./team")

module.exports =
	teamTest:
		'hashcode makes simple index': (test) ->
			t = team("Name with spaces and Upper Case")
			test.equals("namewithspacesanduppercase", t.hashcode())
			test.done()
		
		'new teams are always unique': (test) ->
			t = team("Arsenal")
			t2 = team("Arsenal")
			test.strictEqual(t, t2, "Teams are not the same object when they should be")
			test.done()
