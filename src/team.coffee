###
 * New coffeescript file
###
Immutable = require('./immutable')
teams = {}

factory = (teamName) ->
	t = new Team(teamName);
	return teams[t.hashcode()] if t.hashcode() of teams
	teams[t.hashcode()] = t

class Team extends Immutable
	constructor: (name) ->
		@[k] = v for k, v of @_buildProperties(['name', '_type'],  {'name': name, '_type': 'Team'})
		_hashcode = @name().toLowerCase().replace().replace(/\s/g, '')
		@hashcode = -> _hashcode

	fromJSON: (data) -> factory(data.name)


module.exports = factory
	