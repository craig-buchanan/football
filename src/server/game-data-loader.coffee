###
 * New coffeescript file
###
define ['config', 'fs', 'game', 'q', 'json-serialize'], (config, fs, game, q, json) ->
	(key, year) ->
		defer = q.defer()
		fileName = config.football.data_store + "/" + key + "_" + year
		
		fs.readFile fileName, (err, data)->
			
			return defer.reject(err) if err
			gamesData = JSON.parse(data)
			games = []
			games.push(game.deserialize(g)) for g in gamesData
			defer.resolve(games)
		defer.promise

