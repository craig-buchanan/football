module.exports = (grunt) ->
	grunt.initConfig	
		pkg: grunt.file.readJSON 'package.json'
		watch:
			coffee:
				files: ['src/**/*', 'test-coffee/**/*']
				tasks: ['clean', 'coffee', 'nodeunit', 'jade', 'requirejs']

		coffee:
			compile:
				expand: true
				flatten: false
				cwd: "#{__dirname}/src/"
				src: ['**/*.coffee'],
				dest: 'lib/',
				ext: '.js'
		
			test_compile:
				expand: true
				flatten: false
				cwd: "#{__dirname}/test-coffee/"
				src: ['**/*.coffee'],
				dest: 'test/',
				ext: '.js'
		nodeunit:
			all: ['test/**/*.js'],
		
		requirejs:
			compile:
				options:
					baseUrl: '.'
					appDir: 'lib/client'
					dir: 'public'
					modules: [
						name: 'index'
					]
					paths: 
						angular: '//ajax.googleapis.com/ajax/libs/angularjs/1.2.25/angular.min.js'
						q: '//'
						text: '../../node_modules/requirejs-text/text'

					text:
						env: 'node'

					findNestedDependencies: true

		ngtemplates:
			FootballApp:
				cwd: "lib/client"
				src: "**/*.html"
				dest: "lib/client/templates.js"
				options:
					bootstrap: (module, script) ->"(function() {define(['angular'], function(ng){ " + script + "})}())"


		jade:
			compile:
				options:
					pretty: true
					client: false
				files: [
					(
						cwd: "src"
						dest:	"lib/"
						src:	"**/*.jade"
						expand: true
						ext: ".html"
					)
				]

		clean: ['lib/', 'public/', 'test/']
				
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-contrib-watch'
	grunt.loadNpmTasks 'grunt-contrib-nodeunit'
	grunt.loadNpmTasks 'grunt-contrib-requirejs'
	grunt.loadNpmTasks 'grunt-contrib-jade'
	grunt.loadNpmTasks 'grunt-angular-templates'
	grunt.loadNpmTasks 'grunt-contrib-clean'
	grunt.registerTask 'default', ['clean', 'coffee', 'nodeunit', 'jade', 'requirejs']