###
 * New coffeescript file
###
define [], () ->
	class Immutable
		constructor: ->
		
		_buildProperties: (propsList, constructorArgs) ->
			returnArgs =
				_properties: () -> propsList
				_serialize: () -> constructorArgs
			for attr in propsList
				do(attr) ->
					returnArgs[attr] = () -> constructorArgs[attr]
			returnArgs


	return Immutable