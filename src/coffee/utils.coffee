getOrCall   = (value) -> if isFunc(value) then value() else value
isBool      = (value) -> typeof value == 'boolean'
isNumber    = (value) -> typeof value == 'number'
isString    = (value) -> typeof value == 'string' or value == value + ''
isObject    = (value) -> typeof value == 'object'
isFunc      = (value) -> typeof value == 'function'
isDom       = (value) -> value instanceof HTMLElement
isDomText   = (value) -> value instanceof Text
isNot       = (value) -> value == null or value == undefined
isSimple    = (value) -> (t = typeof value) == 'string' or t == 'number' or t == 'boolean'
extendsNode = (value) -> isFunc(value) and ((value.prototype instanceof ViewNode) or value == ViewNode)


normalizeName = (name) ->
    name.replace /[A-Z]/g, (name) ->
        '-' + name.toLowerCase()


normalizeEvent = (type) ->
    type = type.slice 2
    type.charAt(0).toLowerCase() + normalizeName type.slice(1)
    
    
module.exports = 
    getOrCall:      getOrCall
    isBool:         isBool
    isNumber:       isNumber
    isString:       isString
    isObject:       isObject
    isFunc:         isFunc
    isDom:          isDom
    isDomText:      isDomText
    isNot:          isNot
    isSimple:       isSimple
    extendsNode:    extendsNode
    normalizeName:  normalizeName
    normalizeEvent: normalizeEvent
