getOrCall      = (value) -> if isFunc(value) then value() else value
isBool         = (value) -> typeof value == 'boolean'
isNumber       = (value) -> typeof value == 'number'
isString       = (value) -> typeof value == 'string'
isObject       = (value) -> typeof value == 'object'
isFunc         = (value) -> typeof value == 'function'
isDom          = (value) -> value and value.nodeType == 1
isDomText      = (value) -> value and value.nodeType == 3
isNot          = (value) -> value == null or value == undefined
isSimple       = (value) -> (t = typeof value) == 'string' or t == 'number' or t == 'boolean'
extendsNode    = (value) -> isFunc(value) and (isFunc(value.prototype.render) or value == ViewNode)
isNodeInstance = (value) -> value and value.__id__ and value.render
isArray        = Array.isArray


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
    isArray:        isArray
    isFunc:         isFunc
    isDom:          isDom
    isDomText:      isDomText
    isNot:          isNot
    isSimple:       isSimple
    extendsNode:    extendsNode
    normalizeName:  normalizeName
    normalizeEvent: normalizeEvent
    isNodeInstance: isNodeInstance
