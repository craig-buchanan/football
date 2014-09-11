###
 * Football Game
###
Immutable = require('./immutable')
class Game extends Immutable
	constructor: (args) ->
		@[k] = v for k, v of @_buildProperties(['date', 'homeTeam', 'awayTeam', 'home', 'away'],  args)

	played: () -> @home() isnt null and @away() isnt null

	winner: () ->
		return null if @home() == @away()
		if @home() > @away() then @homeTeam() else @awayTeam()

	teamPoints: (team) ->
		return null if !@played()
		return null if team isnt @homeTeam() and team isnt @awayTeam()
		return 3 if @winner() is team;
		if @away() == @home() then 1 else 0

	teamGoals: (team) ->
		return 0 if !@played()
		return 0 if team isnt @homeTeam() and team isnt @awayTeam()
		if @homeTeam() == team then @home() else @away() 

	teamGoalsAgainst: (team) ->
		return 0 if !@played()
		return 0 if team isnt @homeTeam() and team isnt @awayTeam()
		if @homeTeam() == team then @away() else @home() 

	opponent: (team) -> 
		return false if !@played()
		return null if team isnt @homeTeam() and team isnt @awayTeam()  
		if @homeTeam() == team then @awayTeam() else @homeTeam()

	toString: ->
		scores = if @played() then @home() + ":" + @away() else "-"
		@date() +  " - " + @homeTeam().name() + " vs " + @awayTeam().name() + " " + scores

module.exports = (date, hT, aT, h, a) ->
	new Game({date: date, homeTeam: hT, awayTeam: aT, home: h, away: a})
	
	