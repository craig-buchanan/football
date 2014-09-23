
mockery = require('mockery')

includeFile = '../../../lib/client/points-comparison/points-comparison'

module.exports.pointsComparisonControllerTest =
	"Test Simple": (test) ->
		pc = require(includeFile)
		test.equal(typeof pc, 'function')
		test.equal(pc().restrict, 'E')
		test.ok(pc().replace)
		controllerDef = pc().controller
		test.equal('$scope', controllerDef[0])
		test.equal(typeof controllerDef[controllerDef.length-1], 'function')
		test.equal(pc().scope.selection, '=')
		test.done()