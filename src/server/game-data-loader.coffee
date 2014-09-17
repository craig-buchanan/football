###
 * New coffeescript file
###
define ['config', 'fs', 'q', 'path'], (config, fs, q, path) ->
	(key, year) ->
		defer = q.defer()
		fileName = path.join config.football.data_store, key + "_" + year + ".json"
		console.log "the fileName is: " + fileName;
		fs.readFile fileName, (err, data)->
			console.log(err) if err
			return defer.reject err  if err
			return defer.resolve data.toString()
		defer.promise

