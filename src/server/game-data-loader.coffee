###
 * New coffeescript file
###

define ['config', 'fs', 'q', 'path'], (config, fs, q, path) ->
	
	dataFromSrc = (key, year, fileName) ->
		defer = q.defer() 
		if(year < 2014)
			require ['./server/betexplorer-parser'], (be_parser) ->
				be_parser[key](year).parse().then (games) ->
					data = JSON.stringify(games)
					fs.writeFile fileName, JSON.stringify(games) , (err) ->
						defer.resolve data
				, (error) ->
					defer.reject
			, (error) -> console.log(error)
		else
			defer.reject
		defer.promise
	(key, year) ->
		defer = q.defer()
		fileName = path.join config.football.data_store, key + "_" + year + ".json"
		fs.readFile fileName, (err, data)->
			if err
				return dataFromSrc(key, year, fileName).then (games) -> 
					defer.resolve(games)
				, (err)-> defer.reject err
			return defer.resolve data.toString()
		defer.promise

