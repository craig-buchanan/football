###
 * New coffeescript file
###
teams = {}

class Team
	constructor: (@name) ->
		@_hashcode = @name.toLowerCase().replace().replace(/\s/g, '')

	hashcode: ()-> 
		@_hashcode


module.exports = (teamName) ->
	t = new Team(teamName);
	return teams[t.hashcode()] if t.hashcode() of teams
	teams[t.hashcode()] = t
	