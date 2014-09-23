###
 * New coffeescript file
###

team = require('../../lib/client/team')
game = require('../../lib/client/game')

t1 = team("Arsenal")
t2 = team("Tottenham")
t3 = team("Hull")

fixedDate = new Date("2012-05-04T22:00:00.000Z")
now = new Date()
g1 = game.newGame(fixedDate, t1, t2, 5, 0)
g2 = game.newGame(now, t1, t2, 0, 0)
g3 = game.newGame(now, t2, t1, 1, 4)
g4 = game.newGame(now, t2, t3)
g5 = game.newGame(fixedDate, t2, t3)
exports.GameTest =
	"played is false when home or away are null": (test) ->
		test.ok(!g4.played(), "played function is not working")
		test.done()

	"played is true when home and away are not null": (test) ->
		test.ok(g1.played())
		test.done()
		
	"teamPoints == 3 when team matches homeTeam and homeTeam is winner": (test) ->
		test.strictEqual(g1.homeTeam(), t1)
		test.equals(g1.teamPoints(t1), 3 )
		test.done()
	
	"teamPoints == null when given team is not in game": (test) ->
		test.strictEqual(g1.teamPoints(team("fake team")), null)
		test.done()
		
	"teamPoints == 1 when it is a draw": (test)->
		test.equal(g2.teamPoints(t1), 1)
		test.done()
	
	"teamPoints == 0 when team loses": (test) ->
		test.strictEqual(g1.teamPoints(t2), 0)
		test.done()
		
	"teamGoals correct for home team": (test) ->
		test.equal(g1.teamGoals(t1), 5)
		test.done()
		
	"teamGoals correct for away team": (test) ->
		test.strictEqual(g1.teamGoals(t2), 0)
		test.done()

	"teamGoals is 0 for team that didn't play": (test) ->
		test.strictEqual(g1.teamGoals(team("Fake Team")), 0)
		test.done()
		
	"opponent is correct": (test) ->
		test.strictEqual(g1.opponent(t1), t2)
		test.strictEqual(g1.opponent(t2), t1)
		test.done()
	
	"goals against calculated correctly": (test) ->
		test.strictEqual(g1.teamGoalsAgainst(t1), 0)
		test.strictEqual(g1.teamGoalsAgainst(t2), 5)
		test.done()

	"teamGoalsAgainst is 0 if game is not played": (test) ->
		test.strictEqual(g4.teamGoalsAgainst(t1), 0)
		test.done()

	"teamGoalsAgainst is 0 if game team is not in game": (test) ->
		test.strictEqual(g1.teamGoalsAgainst(team("Fake")), 0)
		test.done()

	"opponent is null when given team is did not play in game": (test) ->
		test.strictEqual(g1.opponent(team("Fake")), null)
		test.done()

	"toString": (test) ->
		test.equal(g1.toString(), "Sat May 05 2012 00:00:00 GMT+0200 (CEST) - Arsenal vs Tottenham 5:0")
		test.equal(g5.toString(), "Sat May 05 2012 00:00:00 GMT+0200 (CEST) - Tottenham vs Hull -")
		test.done()

	"equals works": (test) ->
		test.ok(!g1.equals("string"))
		test.ok(!g1.equals(t1))
		test.ok(g1.equals(g1))
		test.ok(!g3.equals(g4), "Should be unequal when only away teams are different")
		test.ok(!g4.equals(g5), "Should be unequal when only date is different")
		test.ok(!g1.equals(g3), "2 different games are not inequal")
		g3 = game.newGame(g1.date(), t1, t2, 4, 4)
		test.ok(g1.equals(g3), " equals with date and teams is not working")
		test.done()
	
	"from json works": (test) ->
		data = JSON.stringify(g1)
		unserialized = game.deserialize(JSON.parse(data))
		test.ok(g1.equals(unserialized), " deserialized object is not equal to original object")
		test.done()
		