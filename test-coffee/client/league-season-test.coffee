requirejs = require('requirejs')
requirejs.config
	baseUrl: 'lib/client',
	paths:
		text: '../../node_modules/requirejs-text/text'
		data: '../../data'
	nodeRequire: require
league =
	key: ()->"EN1"

ls = require('../../lib/client/league-season')
teams = require('../../lib/client/team')

testData1 = requirejs('text!data/EN1_2013.json')
testData2 = requirejs('text!data/EN1_2014-test.json')

q = require('q')

dataLoader = {}

dataLoader.getSeasonGames = (@key, @year) ->

	d = q.defer()
	if year == 2014
		d.resolve JSON.parse(testData2)
	else
		d.resolve JSON.parse(testData1)
	d.promise

LeagueSeason = ls(dataLoader, q)
module.exports.LeagueSeasonTest =
	"test games are correctly loaded": (test)->
		season = new LeagueSeason({'league': league, beginYear: 2010})
		season.games().then (games)->
			test.equals(games.length, 380)
			test.equals(games[0].homeTeam().name(), "Arsenal")
			test.done()

	"test teams are created correctl": (test)->
		season = new LeagueSeason({'league': league, beginYear: 2010})
		season.teams().then (teams) ->
			test.equals(teams.length, 20)
			test.equals(teams[0].name(), "Arsenal")
			test.done()

	"test standings gives table snapshot at gameday": (test)->
		season = new LeagueSeason({'league': league, beginYear: 2010})
		season.standings().then (standings) ->

			test.equals(standings[0].team().name(), "Manchester City")
			test.equals(standings[0].wins(), 27, "Wins are not calculated correctly")
			test.equals(standings[0].draws(), 5, "Draws are not calculated correctly")
			test.equals(standings[0].losses(), 6, "Losses are not calculated correctly")
			test.equals(standings[0].points(), 86, "Points are not calculated correctly")
			test.equals(standings[0].goals(), 102, "Goals are not calculated correctly")
			test.equals(standings[0].against(), 37, "Goals against are not calculated correctly")
			test.equals(standings[0].diff(), 65, "Goal difference is not calculated correctly")
			test.equals(standings[0].weighting(), 86065.102, "Weighting is not calculated correctly")
			test.equals(standings[3].position(), 4, "The positions are not calculated correctly")

			test.done()

	"test standings gives correct results when games have not been played yet": (test)->
		season = new LeagueSeason({'league': league, beginYear: 2014})
		season.standings().then (standings) ->

			test.equals(standings[0].team().name(), "Chelsea", "Games are not calculated correctly")
			test.equals(standings[0].games(), 4, "Games are not calculated correctly")
			test.equals(standings[0].wins(), 4, "Wins are not calculated correctly")
			test.equals(standings[0].weighting(), 12009.015, "Weighting is not calculated correctly")
			test.done()

	"test standings for team give all results for team as standings": (test) ->

		season = new LeagueSeason({'league': league, beginYear: 2013})
		season.standingsForTeam(teams "Arsenal").then (standings) ->
			test.equal(standings.length, 38)
		season.standingsForTeam(teams "Arsenal").then (standings) ->
			test.equal(standings.length, 38)
			test.done()