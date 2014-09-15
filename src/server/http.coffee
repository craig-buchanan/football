###
 * New coffeescript file
###
q = require('q')
request = require('request')
http = (url) ->
	defer = q.defer()
	request url, (err, response, data)->
		return defer.reject(err) if err
		defer.resolve({'response': response, 'data': data})
	defer.promise
module.exports = http 
	

