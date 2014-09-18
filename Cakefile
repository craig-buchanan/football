{exec} = require 'child_process'
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
	invoke('build')
