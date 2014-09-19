module.exports = (grunt) ->
	grunt.initConfig	
		pkg: grunt.file.readJSON 'package.json'
		watch:
			coffee:
				files: ['src/**/*.coffee', 'test-coffee/**/*.coffee']
				tasks: ['clean', 'coffee', 'nodeunit', 'requirejs']
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
					appDir: 'lib'
					dir: 'public'
					modules: [
						name: 'client/index'
					]
				
					findNestedDependencies: true
		
		clean: ['lib/', 'public/', 'test/']
				
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-contrib-watch'
	grunt.loadNpmTasks 'grunt-contrib-nodeunit'
	grunt.loadNpmTasks 'grunt-contrib-requirejs'
	grunt.loadNpmTasks 'grunt-contrib-clean'
	grunt.registerTask 'default', ['clean', 'coffee', 'nodeunit', 'requirejs']