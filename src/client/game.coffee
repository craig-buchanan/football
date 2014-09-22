`if (typeof define !== 'function') { var define = (require('amdefine'))(module); }`

define ['./immutable', './team'], (Immutable, team) ->
	class Game extends Immutable
		constructor: (args) ->
			@[k] = v for k, v of @_buildProperties(['date', 'homeTeam', 'awayTeam', 'home', 'away'],  args)
	
		played: () -> @home()? and @away()?
	
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
		
		equals: (other) ->

			return false if typeof other != 'object'
			return false if other.constructor != this.constructor
			return false if this.homeTeam() != other.homeTeam()
			return false if this.awayTeam() != other.awayTeam()
			return false if this.date().getTime() != other.date().getTime()
			return true;

	newGame: (date, hT, aT, h, a) ->

		home = if h? then parseInt(h) else null
		away = if a? then parseInt(a) else null
		new Game({date: date, homeTeam: hT, awayTeam: aT, home: home, away: away})

	deserialize: (data) ->

		home = if data.home? then parseInt(data.home) else null
		away = if data.away? then parseInt(data.away) else null
		this.newGame(new Date(data.date), team(data.homeTeam.name), team(data.awayTeam.name), home, away)
	
	