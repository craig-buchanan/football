###
 * New coffeescript file
###
request = require 'request'
cheerio = require 'cheerio'

class SeasonConfig
	constructor:(@key, @url ) ->

n = parseInt(new Date().getTimezoneOffset() / 60);

hrOffset = (year, month,  day, tz) ->
	if(tz == "england")
		
#timeZoneHourAdjustCalc = (date, tz) ->
#	tzList = 
#		"england": (d) -> 
#			if d < new Date(Date.UTC(2014, 9, 26, 1))
#	utcTimeDay = 26
parseDate = (beginYear, dateStr) ->
	
	[day, month, time] = trim(dateStr).replace(/\s-\s/, ' ').toLowerCase().split(/\s/)
	day = parseInt(day)
	time = [hrs, min] = trim(time).split(/:/).map((i) -> parseInt(i));
	monthVal = ''
	monthVal = index+1 for mon, index in month_map when mon == month
	year = if monthVal > 5 then beginYear else beginYear + 1
	return new Date(Date.UTC(year, monthVal, day, hrs, min, 0))

url = 'http://www.soccerstats.com/table.asp?league=england&tid=b';
trim = (str) ->
	str.replace(/(?:(?:^|\n)\s+|\s+(?:$|\n))/g,'').replace(/\s+/g,' ')

month_map = ['jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec']


	
	
	
	
module.exports = (beginYear) ->
#	date = parseDate(beginYear," \n			25 May - 15:00\n\n")
#	console.log(date)
	request url, (err, resp, body) ->
		$ = cheerio.load(body);
		#CSS SELECTOR
		rows = $('.tabbertab .trow3') 
		$(rows).each (i, row) ->
			cells = $(row).find('td')
			date = parseDate(beginYear, $(cells[0]).text())
			return if(!date);
			console.log(date)
			
			
			
			
			
			