###
 * New coffeescript file
###
requirejs = require('requirejs')
requirejs.config
	baseUrl: 'lib',
	nodeRequire: require
team = requirejs('team')
game = requirejs('game')

t1 = team("Arsenal")
t2 = team("Tottenham")
g1 = game(new Date(), t1, t2, 5, 0)
g2 = game(new Date(), t1, t2, 0, 0)

exports.GameTest = 
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
		
	"opponent is correct": (test) ->
		test.strictEqual(g1.opponent(t1), t2)
		test.strictEqual(g1.opponent(t2), t1)
		test.done()
	
	"goals against calculated correctly": (test) ->
		test.strictEqual(g1.teamGoalsAgainst(t1), 0)
		test.strictEqual(g1.teamGoalsAgainst(t2), 5)
		test.done()