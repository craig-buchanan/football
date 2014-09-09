###
 * New coffeescript file
###
request = require 'request';
cheerio = require 'cheerio';


url = 'http://www.soccerstats.com/table.asp?league=england&tid=b';
trim = (str) ->
	str.replace(/(?:(?:^|\n)\s+|\s+(?:$|\n))/g,'').replace(/\s+/g,' ')
	
month_map = ['jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec'] 

module.exports = () ->
	request url, (err, resp, body) ->
		$ = cheerio.load(body);
		#CSS SELECTOR
		rows = $('.tabbertab .trow3') 
		$(rows).each (i, row) ->
			cells = $(row).find('td')
			[day, month, time] = trim($(cells[0]).text()).replace(/\s-\s/, ' ').toLowerCase().split(/\s/);
			monthVal = ''
			monthVal = index+1 for mon, index in month_map when mon == month
				
			text = day + '.' + monthVal + ' ' + time + ' ' + trim($(cells[1]).text()) + ' ' + trim($(cells[2]).find('font b').text());
			console.log text