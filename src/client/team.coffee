`if (typeof define !== 'function') { var define = (require('amdefine'))(module); }`

define ['./immutable'], (Immutable) ->
	teams = {}


	teamNameMap =
		'Manchester United':		'Manchester Utd'
		'West Bromwich': 				'West Brom'
		'West Ham Utd': 				'West Ham'
		'QP Rangers': 					'QPR'
		'Swansea City':					'Swansea'
		'B. Moenchengladbach': 	'Mönchengladbach'
		'FC Augsburg':					'Augsburg'
		'Hannover 96':					'Hannover'
		'Eintracht Frankfurt':	'Frankfurt'
		'FSV Mainz 05': 				'Mainz'
		'Schalke 04':						'Schalke'
		'Hamburger SV':					'Hamburg'
		'Hamburger':						'Hamburg'
		'Bayer Leverkusen':			'Leverkusen'
		'VfB Stuttgart':				'Stuttgart'
		'FC Köln':							'Köln'
		'Brighton & Hove':			'Brighton'
		'Derby County':					'Derby'
		'Leeds Utd':						'Leeds'
		'Wigan Athletic':				'Wigan'
		'Birmingham City':			'Birmingham'
		'Cardiff City':					'Cardiff'
		'Ipswich Town':					'Ipswich'
		'Nottm Forest':					'Nottingham F.'
		'Nottingham Forest':		'Nottingham F.'
		'Nottingham':						'Nottingham F.'
		'Norwich City':					'Norwich'
		'Dusseldorf':						'Düsseldorf'


	class Team extends Immutable
		constructor: (name) ->
			@[k] = v for k, v of @_buildProperties(['name'],  {name: name})
			_hashcode = @name().toLowerCase().replace().replace(/\s/g, '')
			@hashcode = -> _hashcode

	return (teamName) ->
		teamName = teamNameMap[teamName] if teamName of teamNameMap

		t = new Team(teamName);
		return teams[t.hashcode()] if t.hashcode() of teams
		teams[t.hashcode()] = t
	