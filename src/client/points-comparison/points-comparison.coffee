`if (typeof define !== 'function') { var define = (require('amdefine'))(module); }`

define ['text!./points-comparison.html'], (templ) ->

	class PointsComparisonController
		constructor: (scope, q, $window) ->
			console.log("points comparison initialized")


			scope.$watch 'selection.season', (season)->
				season.teams().then (teams)->
					scope.range = [0..((teams.length-1)*2-1)]
				allSeasons = scope.selection.league.seasons()
				for val, index in scope.selection.league.seasons()
					currentIndex = index if val.beginYear() == season.beginYear()
				currentIndex = 2 if currentIndex < 2
				scope.selectedSeasons = allSeasons[currentIndex-2..currentIndex]
				futures = scope.selectedSeasons.map (s)-> s.standingsForTeam(scope.selection.team)

				q.all(futures).then (standings)-> scope.standings = standings

			scope.getPointsClass = (standing) ->

				return "" if !standing or !standing.game().played()
				points = standing.game().teamPoints(scope.selection.team)
				return "win" if points == 3
				return "draw" if points == 1
				"loss"

			[scope.mLocY, scope.mLocX] = [0,0]
			scope.setMousePoints = (event) -> [scope.mLocY, scope.mLocX] = [$window.innerHeight - event.clientY + 5, $window.innerWidth - event.clientX + 5]

			scope.gameDataStyle = () ->
				hash =
					top: mLocY
					left: mLocX


			scope.gameData = (game) ->

				t = scope.selection.team
				return "no game " if !game

				retStr = if game.homeTeam() == t then "H. " else "A. "
				retStr += game.opponent(t).name() + " "
				if !game.played()

					[day, mon, hr, min] = [game.date().getDate(), game.date().getMonth()+1, game.date().getHours(), game.date().getMinutes()].map (v)-> if v < 10 then "0" + v else "" + v
					return retStr + "#{day}.#{mon} #{hr}:#{min}"
				retStr + game.home() + " : " + game.away()

			scope.colNumber = (index) ->
				"col-" + (index + 1)
	()->
		restrict: 'E'
		replace: true
		scope:
			selection: '='
		template: templ
		controller: ['$scope', '$q', '$window', PointsComparisonController]

