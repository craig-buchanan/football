###
 * New coffeescript file
###
class Immutable
	constructor: ->
	
	_buildProperties: (propsList, constructorArgs) ->
		args = {}
		args[k] = v for k,v of constructorArgs
		returnArgs =
			_properties: () -> propsList
			toJSON: () -> 
				simpleObj = {}
				for k, v of args
					if(v != null && typeof v == 'object' && 'toJSON' of v)
						simpleObj[k] = v.toJSON()
					else
						simpleObj[k] = v 
				simpleObj
		for attr in propsList
			do(attr) ->
				returnArgs[attr] = () -> args[attr]
		returnArgs

module.exports = Immutable