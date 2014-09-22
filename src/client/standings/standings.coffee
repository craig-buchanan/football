`if (typeof define !== 'function') { var define = (require('amdefine'))(module); }`

define ['text!./standings.html'], (templ) ->

	class StandingsController
		constructor: (@scope, q) ->
			console.log "standings controller called"
			sortField = 'P';
			sortReverse = false

			scope.$watch 'selection.season', (s) ->
				return if !s
				s.standings().then (standings) ->
						scope.table = standings


			scope.titleClass = (fld) ->
				if sortField == fld then 'active' else ''

			scope.selectTeam = (team) ->
				scope.selection.team = team
				scope.selection.mode = 'fixture-comparison'

			scope.doSort = (fld) ->

				if fld == sortField then sortReverse = !sortReverse else sortReverse = false
				if(sortReverse) then key = fld + '-' else key = fld
				sortField = fld;

				scope.table.sort(sorts[key])

			sorts =
				'P':    (a, b) -> a.position - b.position
				'P-':   (b, a) -> sorts.P(a, b)
				'GD':   (a, b) -> b.diff() - a.diff() || sorts.P(a, b)
				'GD-':  (b, a) -> sorts.GD(a, b)
				'GA':	  (a, b) -> a.against - b.against || sorts.P(a, b)
				'GA-':	(b, a) -> sorts.GA(a, b)
				'GF':	  (a, b) -> b.goals - a.goals || sorts.P(a, b)
				'GF-':	(b, a) -> sorts.GF(a, b)
				'W':	  (a, b) -> b.wins - a.wins || sorts.P(a, b)
				'W-':	  (b, a) -> sorts.W(a, b)
				'D':	  (a, b) -> b.draws - a.draws || sorts.P(a, b)
				'D-':	  (b, a) -> sorts.D(a, b)
				'L':	  (a, b) -> a.losses - b.losses || sorts.P(a, b)
				'L-':	  (b, a) -> sorts.L(a, b)
				'G':	  (a, b) -> b.wins - a.wins || sorts.P(a, b)
				'G-':	  (b, a) -> sorts.G(a, b)

	() ->
		restrict: 'E'
		scope:
			selection: '='
		template: templ
		controller: ['$scope', '$q', StandingsController]



