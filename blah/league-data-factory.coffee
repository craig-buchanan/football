###
 * LeagueDataFactory Test
###

league		= require('../lib/league')
ldf				= require('../lib/league-data-factory')
injector 	= require('../lib/injector')

exports.LeagueDataFactoryTest =
	"season can be loaded from stored file": (test) ->
		factory = ldf.getDataFactory()
		test.ok(factory != null, "The data factory was not correctly instanciated")
		ldf.getDataFactory().getData(league.factory(injector).EN1, 2014).then( (games) -> 
			
			test.equals(games.length, 380)
			g.toString() for g in games
			test.done()
		)