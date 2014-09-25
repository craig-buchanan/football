
mockery = require('mockery')
mockery.registerMock('text', {load: (str)-> "<div>template</div>"})
includeFile = '../../../lib/client/points-comparison/points-comparison'

class MockScope
	constructor: ()->
		@__watches = {}

	$watch: (property, callback)->
		@__watches[property] = callback

	triggerWatch: (property, value)->
		@__watches[property](value)

class MockSeason
	constructor: (@beginYear)->
	beginYear: ()->@beginYear

[mockQ] = [null]

module.exports.pointsComparisonControllerTest =
	setUp: (callback) ->
		mockQ =
			all: (args)->
				then: ()->
					args

		mockery.enable(useCleanCache:true)

		mockery.registerAllowable(includeFile)
		mockery.registerAllowables(['amdefine', 'path'])
		callback()

	tearDown: (callback)->
		mockery.disable();
		callback()

	"directive is defined properly": (test) ->

		pc = require(includeFile)
		test.equal(typeof pc, 'function')
		test.equal(pc().restrict, 'E')
		test.ok(pc().replace)
		controllerDef = pc().controller
		test.equal('$scope', controllerDef[0])
		test.equal(typeof controllerDef[controllerDef.length-1], 'function')
		test.equal(pc().scope.selection, '=')
		test.done()


	"sets selected season to correct 3 seasons": (test)->
		pc = require(includeFile)()

		seasons = [
			(

				beginYear: ()-> 2000
				standingsForTeam: ()-> 0
			)
			(
				beginYear: ()-> 2001
				standingsForTeam: ()-> 1
			)
			(
				beginYear: ()-> 2002
				standingsForTeam: ()-> 2
			)
			(
				beginYear: ()-> 2003
				standingsForTeam: ()-> 3
			)
			(
				beginYear: ()-> 2004
				standingsForTeam: ()-> 4
			)
		]
		teamFutureMock = () ->
			then: ()-> [0..19]

		mockScope = new MockScope()
		mockScope.selection =
			league: {seasons: ()-> seasons}
			season: {beginYear: ()-> 2003}

		controller = new pc.controller[pc.controller.length-1](mockScope, mockQ)
		mockScope.triggerWatch('selection.season', {beginYear:(()-> 2003), teams: teamFutureMock})
		test.equal(mockScope.selectedSeasons.length, 3)
		test.equal(mockScope.selectedSeasons[0].beginYear(), 2001)

		mockScope.triggerWatch('selection.season', {beginYear:(()-> 2001), teams: teamFutureMock})
		test.equal(mockScope.selectedSeasons.length, 3)
		test.equal(mockScope.selectedSeasons[0].beginYear(), 2000)
		test.equal(mockScope.selectedSeasons[2].beginYear(), 2002)
		test.done()


