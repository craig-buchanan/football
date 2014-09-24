`if (typeof define !== 'function') { var define = (require('amdefine'))(module); }`

define [], () ->
	class PointsComparisonController
		constructor: () ->

	()->
		restrict: 'E'
		replace: true
		scope:
			selection: '='
		controller: ['$scope', PointsComparisonController]

