`if (typeof define !== 'function') { var define = (require('amdefine'))(module); }`

define ['angular', 'league', 'game-data-loader', 'standings/standings', 'fixture-comparison/fixture-comparison', 'points-comparison/points-comparison', 'text!football.html'], (ng, leagues, gdl, standings, fixtureComparison, pointsComparison, templ) ->

	class FootballController
		constructor: (@scope, leagues) ->
			@scope.leagues = leagues

			@scope.selection =
				league: leagues[0]
				season: leagues[0].getSeason(2014)
				mode: "standings"

	footballDirective = () ->
		restrict: 'E'
		replace: true
		scope: {}
		template: templ
		controller: ['$scope', "leagues", FootballController]

	ng.module 'FootballApp', []
		.service "gameDataLoader", ['$http', '$q', gdl]
		.service "leagues", ['gameDataLoader', '$q', leagues]
		.directive "football",  footballDirective
		.directive "standings", standings
		.directive "fixCmp", fixtureComparison
		.directive "pointsComparison", pointsComparison