#!/bin/bash

mkdir $1
cd $1

nvm use 0.10

npm init

echo "This is a readme" >> Readme.md

npm install grunt-cli --save-dev
npm install grunt --save-dev
npm install grunt-contrib-coffee --save-dev
npm install nodeunit --save-dev
npm install grunt-contrib-nodeunit --save-dev
npm inst grunt-contrib-requirejs --save-dev
npm install grunt-contrib-watch --save-dev
npm install grunt-contrib-clean --save-dev
npm install grunt-contrib-jade --save-dev


npm install requirejs --save
npm install amdefine --save

mkdir src
mkdir src-test

echo "module.exports = (grunt) ->" >> Gruntfile.coffee
echo -e "\tgrunt.initConfig" >> Gruntfile.coffee
echo -e "\t\tpkg: grunt.file.readJSON 'package.json'" >> Gruntfile.coffee
echo -e "\t\tcoffee:" >> Gruntfile.coffee
echo -e "\t\t\tcompile:" >>Gruntfile.coffee
echo -e "\t\t\t\texpand: true" >> Gruntfile.coffee
echo -e "\t\t\t\tflatten: false" >> Gruntfile.coffee
echo -e "\t\t\t\tcwd: \"#{__dirname}/src/\"" >> Gruntfile.coffee
echo -e "\t\t\t\tsrc: ['**/*.coffee']" >> Gruntfile.coffee
echo -e "\t\t\t\tdest: 'lib/'" >> Gruntfile.coffee
echo -e "\t\t\t\text: 'js'" >> Gruntfile.coffee

echo -e "\t\t\ttest_compile:" >>Gruntfile.coffee
echo -e "\t\t\t\texpand: true" >> Gruntfile.coffee
echo -e "\t\t\t\tflatten: false" >> Gruntfile.coffee
echo -e "\t\t\t\tcwd: \"#{__dirname}/src-test/\"" >> Gruntfile.coffee
echo -e "\t\t\t\tsrc: ['**/*.coffee']" >> Gruntfile.coffee
echo -e "\t\t\t\tdest: 'test/'" >> Gruntfile.coffee
echo -e "\t\t\t\text: '.js'" >> Gruntfile.coffee

echo -e "\t\tnodeunit:" >> Gruntfile.coffee
echo -e "\t\t\tall:['test/**/*.js']" >>Gruntfile.coffee


echo -e "\t\tgrunt.loadNpmTasks 'grunt-contrib-coffee'" >> Gruntfile.coffee
echo -e "\t\tgrunt.loadNpmTasks 'grunt-contrib-watch'" >> Gruntfile.coffee
echo -e "\t\tgrunt.loadNpmTasks 'grunt-contrib-nodeunit'" >> Gruntfile.coffee
echo -e "\t\tgrunt.loadNpmTasks 'grunt-contrib-requirejs'" >> Gruntfile.coffee
echo -e "\t\tgrunt.loadNpmTasks 'grunt-contrib-jade'" >> Gruntfile.coffee
echo -e "\t\tgrunt.loadNpmTasks 'grunt-contrib-clean'" >> Gruntfile.coffee
echo -e "\t\tgrunt.registerTask 'test', ['coffee', 'nodeunit']" >> Gruntfile.coffee


echo -e "module.exports.sampleTest = " >> src-test/sample-test.coffee
echo -e "\t\"test init functions\": (test)->" >> src-test/sample-test.coffee
echo -e "\t\ttest.ok(true)" >> src-test/sample-test.coffee
echo -e "\t\ttest.done()" >> src-test/sample-test.coffee







