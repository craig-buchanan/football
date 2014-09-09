#!/bin/bash
rm -rf lib/*
rm -rf test/*
coffee --compile --output lib/ src/ 
coffee --compile --output test/ test-coffee/ 

