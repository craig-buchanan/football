###
 * injector interface module
###
class NodeFootballInjector 
	http:							() -> require('./http')
	domParser:				() -> require('cheerio')
	config:						() -> require('config')
	immutable: 				() -> require('./immutable')
	q:								() -> require('q')
	teamFactory:			() -> require('./team')
	gameFactory:			() -> require('./game')
	leagueDataLoader:	() -> {}

module.exports = new NodeFootballInjector