###
 * New coffeescript file
###
define ['./immutable'], (Immutable) ->
	teams = {}
	
	class Team extends Immutable
		constructor: (name) ->
			@[k] = v for k, v of @_buildProperties(['name'],  {name: name})
			_hashcode = @name().toLowerCase().replace().replace(/\s/g, '')
			@hashcode = -> _hashcode

	return (teamName) ->
		t = new Team(teamName);
		return teams[t.hashcode()] if t.hashcode() of teams
		teams[t.hashcode()] = t
	