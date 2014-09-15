parser = require('./soccerstats-parser')
json = require('json-serialize')
fs = require('fs')
q = require('q')
#league = require('./game')
config = require('config')

#l = new league({beginYear: 2014})
#console.log("league begin year should be 2014 and is: " + l.beginYear())
#if l.league()? then console.log("league year is correctly undefined") else console.log("league year is defined")


#parser.EN1_2014(q).then( (games) -> 
#
#	console.log("writing to file ", config.get("Football.data_store") + "/EN1_2014\n")
#	data = JSON.stringify(games)
#	console.log(data)
#	fs.writeFile( config.get("Football.data_store") + "/EN1_2014", data, (err) ->
#	 console.log(err) if err
#	 console.log("file SAVED!")
#	)
#)


