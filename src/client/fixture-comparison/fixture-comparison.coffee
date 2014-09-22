`if (typeof define !== 'function') { var define = (require('amdefine'))(module); }`

define ['text!./fixture-comparison.html'], (templ) ->

	class SeasonTeams
		constructor: (@season1Teams, @season2Teams, compareToTeam) ->
			[@s1Index, @s2Index, @bothIndex, @s1OnlyIndex, @s2OnlyIndex, @bothList, @s1OnlyList, @s2OnlyList] = [{}, {}, {}, {}, {}, [], [], []];


			@s1Index[t.hashcode()] = t for t in @season1Teams
			@s2Index[t.hashcode()] = t for t in @season2Teams

			for key, value of @s2Index
				continue if value == compareToTeam
				if key of @s1Index
					@bothList.push(value)
					@bothIndex[key] = value
				else
					@s2OnlyList.push(value)
					@s2OnlyIndex[key] = value

			for key, value of @s1Index
				continue if value == compareToTeam
				if !(key of @s2Index)
					@s1OnlyList.push(value)
					@s1OnlyIndex[key] = value

		allSorted: () -> @bothList.concat(@s2OnlyList.concat(@s1OnlyList))
		teamInSeason1: (team) -> team.hashcode() of @s1Index
		teamInSeason2: (team) -> team.hashcode() of @s2Index


	class FixtureComparisonController

		constructor: (@scope, q) ->


			recalculate = () ->
				allSeasons = scope.selection.league.seasons()
				rootIndex = allSeasons.length-1
				for v, index in allSeasons by 1
					rootIndex = index if v == scope.selection.season

				rootIndex = 1 if rootIndex == 0
				scope.s2 = allSeasons[rootIndex]
				scope.s1 = allSeasons[rootIndex-1]

				futureData = [
					scope.s1.teams()
					scope.s2.teams()
					scope.s1.gamesForTeam(scope.selection.team)
					scope.s2.gamesForTeam(scope.selection.team)
				]
				q.all(futureData).then (seasonsData) ->

					scope.seasonTeams = new SeasonTeams(seasonsData[0], seasonsData[1], scope.selection.team);
					scope.teamGames =
						s1: seasonsData[2] or []
						s2: seasonsData[3] or []

			scope.$watch 'selection.team', recalculate
			scope.$watch 'selection.season', recalculate

			teamPlayedSeason = (season, team) ->

				return false if season == 's1' && !scope.seasonTeams.teamInSeason1(team)
				return false if season == 's2' && !scope.seasonTeams.teamInSeason2(team)
				true

			isDNP = (season, team) ->

				return true if !teamPlayedSeason(season, scope.selection.team)
				!teamPlayedSeason(season, team)

			resultClass = (res) ->

				return "" if not res
				return "not-played" if !res.played()
				pts = res.teamPoints(scope.selection.team)
				return 'win' if pts == 3
				if pts == 1 then 'draw' else 'loss'

			scope.homeResult = (season, team) ->

				return 'DNP' if isDNP(season, team)
				[res] = scope.teamGames[season].filter((g) -> g.awayTeam() == team)
				return "-:-" if !res.played()
				if res then res.home() + ":" + res.away() else "-"

			scope.homeResultClass = (season, team) ->

				return 'dnp' if isDNP(season, team)
				[res] = scope.teamGames[season].filter((g) -> g.awayTeam() == team)
				resultClass(res)

			scope.awayResult = (season, team) ->

				return 'DNP' if isDNP(season, team)
				[res] = scope.teamGames[season].filter((g) -> g.homeTeam() == team)
				return "-:-" if !res.played()
				if res then res.home() + ":" + res.away() else "-"

			scope.awayResultClass = (season, team) ->

				return 'dnp' if isDNP(season, team)
				[res] = scope.teamGames[season].filter((g) -> g.homeTeam() == team)
				resultClass(res)

	() ->
		restrict: 'E'
		replace: true
		scope:
			selection: '='
		template: templ
		controller: ['$scope', '$q', FixtureComparisonController]


