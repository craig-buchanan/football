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

testData1 = requirejs('text!data/EN1_2010.json')
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
			test.equals(games[0].homeTeam().name(), "Aston Villa")
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

			test.equals(standings[0].team().name(), "Manchester Utd")
			test.equals(standings[0].wins(), 23, "Wins are not calculated correctly")
			test.equals(standings[0].draws(), 11, "Draws are not calculated correctly")
			test.equals(standings[0].losses(), 4, "Losses are not calculated correctly")
			test.equals(standings[0].points(), 80, "Points are not calculated correctly")
			test.equals(standings[0].goals(), 78, "Goals are not calculated correctly")
			test.equals(standings[0].against(), 37, "Goals against are not calculated correctly")
			test.equals(standings[0].diff(), 41, "Goal difference is not calculated correctly")
			test.equals(standings[0].weighting(), 80041.078, "Weighting is not calculated correctly")

			test.done()

	"test standings gives correct results when games have not been played yet": (test)->
		season = new LeagueSeason({'league': league, beginYear: 2014})
		season.standings().then (standings) ->

			test.equals(standings[0].team().name(), "Chelsea", "Games are not calculated correctly")
			test.equals(standings[0].games(), 4, "Games are not calculated correctly")
			test.equals(standings[0].wins(), 4, "Wins are not calculated correctly")
			test.equals(standings[0].weighting(), 12009.015, "Weighting is not calculated correctly")
			test.done()