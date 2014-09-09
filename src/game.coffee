###
 * Football Game
###

class Game
	constructor: (@date, @homeTeam, @awayTeam, @home, @away, @round) ->
		@played = () -> 
			@home isnt null and @away isnt null

	winner: () ->
		return null if @home == @away
		if @home > @away then @homeTeam else @awayTeam
	
	teamPoints: (team) ->
		return null if !@played()
		return null if team isnt @homeTeam and team isnt @awayTeam
		return 3 if @winner() is team;
		if @away == @home then 1 else 0
	
	teamGoals: (team) ->
		return 0 if !@played()
		return 0 if team isnt @homeTeam and team isnt @awayTeam
		if @homeTeam == team then @home else @away 
		
	teamGoalsAgainst: (team) ->
		return 0 if !@played()
		return 0 if team isnt @homeTeam and team isnt @awayTeam
		if @homeTeam == team then @away else @home 
	
	opponent: (team) -> 
		return null if team isnt @homeTeam and team isnt @awayTeam
		if @homeTeam == team then @awayTeam else @homeTeam
		

module.exports = (date, hT, aT, h, a, round) ->
	new Game(date, hT, aT, h, a, round)