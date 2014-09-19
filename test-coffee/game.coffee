###
 * New coffeescript file
###

requirejs = require('requirejs')
requirejs.config
	baseUrl: 'lib',
	paths: {
		'cliserv': 'server'
	}
	nodeRequire: require

	
team = requirejs('team')
game = requirejs('game')
json = requirejs('json-serialize')

t1 = team("Arsenal")
t2 = team("Tottenham")

g1 = game.newGame(new Date(), t1, t2, 5, 0)
g2 = game.newGame(new Date(), t1, t2, 0, 0)
g3 = game.newGame(new Date(), t2, t1, 1, 4)

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
		
	"equals works": (test) ->
		test.ok(g1.equals(g1))
		test.ok(!g1.equals(g3), "2 different games are not inequal")
		g3 = game.newGame(g1.date(), t1, t2, 4, 4)
		test.ok(g1.equals(g3), " equals with date and teams is not working")
		test.done()
	
	"from json works": (test) ->
		data = JSON.stringify(g1)
		unserialized = game.deserialize(JSON.parse(data))
		test.ok(g1.equals(unserialized), " deserialized object is not equal to original object")
		test.done()
		