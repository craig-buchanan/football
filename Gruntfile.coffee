module.exports = (grunt) ->
	grunt.initConfig	
		pkg: grunt.file.readJSON 'package.json'
		watch:
			coffee:
				files: ['src/**/*', 'test-coffee/**/*']
				tasks: ['clean', 'coffee', 'nodeunit', 'jade', 'requirejs']
		coffee:
			compile:
				options:
					bare: true
				expand: true
				flatten: false
				cwd: "#{__dirname}/src/"
				src: ['**/*.coffee']
				dest: 'lib/'
				ext: '.js'
		
			test_compile:
				options:
					bare: true
				expand: true
				flatten: false
				cwd: "#{__dirname}/test-coffee/"
				src: ['**/*.coffee'],
				dest: 'test/',
				ext: '.js'

		nodeunit:
			all: ['test/**/*.js'],

		coverage:
			options:
				thresholds:
					'statements': 90,
					'branches': 90,
					'lines': 90,
					'functions': 90
				dir: '../coverage',
				root: 'test'

		requirejs:
			compile:
				options:
					generateSourceMaps: true
					preserveLicenseComments: false
					optimize: 'uglify2'
					useSourceUrl: true
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

		clean: ['lib/', 'public/', 'test/', 'coverage/']
				
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-contrib-watch'
	grunt.loadNpmTasks 'grunt-contrib-nodeunit'
	grunt.loadNpmTasks 'grunt-contrib-requirejs'
	grunt.loadNpmTasks 'grunt-contrib-jade'
	grunt.loadNpmTasks 'grunt-contrib-clean'
	grunt.loadNpmTasks 'grunt-istanbul-coverage'

	grunt.registerTask 'default', ['clean', 'coffee', 'jade', 'requirejs']