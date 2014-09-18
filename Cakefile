{exec} = require 'child_process'
fs = require 'fs'
requirejs = require 'requirejs'

requirejs.config
	baseUrl: './lib',
	nodeRequire: require

task 'build', 'Build project from src/*.coffee to lib/*.js', ->
	exec 'coffee --compile --output lib/ src/', (err, stdout, stderr) ->
		throw err if err
		console.log stdout + stderr

task 'test', 'Compile everything and run the tests', ->
	invoke 'build'
	exec 'coffee --compile --output test/ test-coffee/', (err, stdout, stderr) ->
		console.log stdout + stderr
		exec 'nodeunit test', (err, stdout, stderr) ->
			console.log stdout + stderr
task 'watch', 'Watch src for changes', ->
	fs.watch(__dirname + "/src", () -> invoke('build'))

task 'concat:js', 'concatenate javascript build artifacts', ->
	r = require 'requirejs'
	c = 
		baseUrl:	'lib/'
		name:		'index'
		out:		'public/index.max.js'
		optimize:	'none'
	r.optimize(c, console.log)