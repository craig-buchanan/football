###
 * Football league
###

Immutable = require('./immutable')

LEAGUES = {
}

class LeagueSeason extends Immutable
	constructor: (args) ->
		@[k] = v for k, v of @_buildProperties(['league', 'beginYear'],  args)
		

module.exports = LeagueSeason