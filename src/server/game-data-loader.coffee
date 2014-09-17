###
 * New coffeescript file
###
define ['config', 'fs', 'game', 'q', 'json-serialize', 'path'], (config, fs, game, q, json, path) ->
	(key, year) ->
		defer = q.defer()
		fileName = path.join config.football.data_store, key + "_" + year + ".json"
		console.log "the fileName is: " + fileName;
		fs.readFile fileName, (err, data)->
			console.log "the file was loaded"
			console.log(err) if err
			return defer.reject(err) if err
			return defer.resolve(JSON.parse(data))
		defer.promise

