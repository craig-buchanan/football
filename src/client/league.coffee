`if (typeof define !== 'function') { var define = (require('amdefine'))(module); }`

define ['./immutable', './league-season'], (Immutable, ls) ->
	LeagueSeason = null
	class League extends Immutable
		constructor: (args) ->
			@[k] = v for k, v of @_buildProperties(['name', 'key', 'beginYear'], args)
			now  = 	new Date()
			endYear = if now.getMonth() > 5 then now.getFullYear() else now.getFullYear()-1
			seasonCount = endYear - @beginYear()

			seasons = []
			seasons.push(new LeagueSeason({league: this, beginYear: @beginYear()+i})) for i in [0..seasonCount] by 1
			@seasons = ()-> seasons
			@getSeason = (year)->
				seasons[year - @beginYear()]

	(dl, qService) ->
		LeagueSeason = ls(dl, qService)
		return [
			new League
				key: 'EN1'
				beginYear: 1998
				name: 'Premier League'
			new League
				key: 'EN2'
				beginYear: 1998
				name: 'Championship'
			new League
				key: 'EN3'
				beginYear: 1998
				name: 'League One'
			new League
				key: 'EN4'
				beginYear: 1998
				name: 'League Two'
			new League
				key: 'DE1'
				beginYear: 1999
				name: 'Bundesliga'
			new League
				key: 'DE2'
				beginYear: 1999
				name: '2. Bundesliga'
		]
	