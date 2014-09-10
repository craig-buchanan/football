###
 * New coffeescript file
###
request 	= require 'request'
cheerio 	= require 'cheerio'
timezone	= require 'timezone'
tz 				=	timezone(require("timezone/Europe"))
teams			= require('./team')
game			= require('./game')

q = null
trim = (str) ->
	str.replace(/(?:(?:^|\n)\s+|\s+(?:$|\n))/g,'').replace(/\s+/g,' ')

month_map =
	jan: '01'
	feb: '02'
	mar: '03'
	apr: '04'
	may: '05'
	jun: '06'
	jul: '07'
	aug: '08'
	sep: '09'
	oct: '10'
	nov: '11'
	dec: '12'

class SoccerStatsLeagueDataParser 
	constructor: (name, @zone, @beginYear) ->
		@url = "http://www.soccerstats.com/table.asp?league=" + name + "&tid=b"
		
	monthYear: (month) ->
		if month > 5 then @beginYear else @beginYear + 1
	
	parseDate: (dateStr) ->
		[day, month, time] = trim(dateStr).replace(/\s-\s/, ' ').toLowerCase().split(/\s/)
		day = parseInt(day);
		day = if day < 10 then "0" + day else day + "" 
		month = month_map[month];
		dateStr = [@monthYear(month), month, day].join("-") + " " + trim(time)
		new Date(tz(dateStr, @zone))
	
	parse: ->
		defer = q.defer()
		request @url, (err, resp, body) =>
				$ = cheerio.load(body);
				games = []
				rows = $('.tabbertab .trow3') 
				$(rows).each (i, row) =>
					cells = $(row).find('td')
					date = @parseDate($(cells[0]).text())
					return if(!date);
					[homeTeam, awayTeam] = $(cells[1]).text().split(/\s-\s/).map (n) -> teams(trim(n))
					[home, away] = [null, null]
					scores = $(cells[2]).find("b")
					if(scores.length)
						[home, away] = $(scores[0]).text().split(/-/)
					
					games.push(game(date, homeTeam, awayTeam, home, away))
				defer.resolve(games);
		
		defer.promise


module.exports = 
		EN_2014: (qService) ->
			q = qService
			new SoccerStatsLeagueDataParser('england', "Europe/London", 2014).parse()
	