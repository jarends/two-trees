__id__ = 0


TEXT_KIND = 0
NODE_KIND = 1


COMP_CFG_ERROR = 'Cfg for creating a node must either be a string or an object containing a tag property as not empty string or a node class.'
VIEW_CFG_ERROR = 'Cfg for creating a view must either be a string or an object containing a tag property as not empty string'


isBool   = (value) -> typeof value == 'boolean'
isNumber = (value) -> typeof value == 'number'
isString = (value) -> typeof value == 'string' or value == value + ''
isObject = (value) -> typeof value == 'object'
isFunc   = (value) -> typeof value == 'function'
isHTML   = (value) -> value instanceof HTMLElement
isNot    = (value) -> value == null or value == undefined
isSimple = (value) ->
    (t = typeof value) == 'string' or t == 'number' or t == 'boolean'




normalizeName = (name) ->
    name.replace /[A-Z]/g, (name) ->
        '-' + name.toLowerCase()




normalizeEvent = (type) ->
    type = type.slice 2
    type.charAt(0).toLowerCase() + normalizeName type.slice(1)




throwNodeCfgError = (cfg) ->
    throw new Error COMP_CFG_ERROR + ' cfg = ' + getCfgJson cfg


throwViewCfgError = (cfg) ->
    throw new Error VIEW_CFG_ERROR + ' cfg = ' + getCfgJson cfg




getCfgJson = (cfg) ->
    try
        c = JSON.stringify cfg
    catch
    c + ''




###
    if cfg is string || boolean || number
        node is a text node

    if cfg is object
        tag can be
            string
                which is mapped to an component class
                the node name

    cfg =
        tag:
        style:
        className:
        children:
        event handlers starting with 'on'

###





class Node


    constructor: (cfg) ->
        @register(cfg)
        #console.log 'ctx: ', @ctx


    register: (@cfg) ->
        @keep = false
        if not @__id__
            @__id__ = ++__id__
            nodeMap[@__id__] = @
        @__id__



    dispose: () -> null


    onMount: () -> null


    onUnmount: () -> @keep


    needsUpdate: () -> true
    canUpdate:   () -> true
    update:      () => update @
    render:      () -> @cfg


    onAdded:   () ->


    onRemoved: () ->


    add:       (child) ->
    addAt:     (child, index) ->
    remove:    (child) ->
    removeAt:  (index) ->




#    00000000   00000000    0000000   00000000    0000000
#    000   000  000   000  000   000  000   000  000     
#    00000000   0000000    000   000  00000000   0000000 
#    000        000   000  000   000  000             000
#    000        000   000   0000000   000        0000000 

tagMap     = {}
rootMap    = {}
nodeMap    = {}
dirtyMap   = {}
dirty      = false
rafTimeout = null




#    00     00   0000000   00000000 
#    000   000  000   000  000   000
#    000000000  000000000  00000000 
#    000 0 000  000   000  000      
#    000   000  000   000  000      

map = (tag, clazz, overwrite = false) ->
    if isNot(tagMap[tag]) or overwrite
        tagMap[tag] = clazz
    null





#    000   000  000   000  00     00   0000000   00000000 
#    000   000  0000  000  000   000  000   000  000   000
#    000   000  000 0 000  000000000  000000000  00000000 
#    000   000  000  0000  000 0 000  000   000  000      
#     0000000   000   000  000   000  000   000  000      

unmap = (tag) ->
    delete tagMap[tag]
    null




#     0000000  00000000   00000000   0000000   000000000  00000000
#    000       000   000  000       000   000     000     000     
#    000       0000000    0000000   000000000     000     0000000 
#    000       000   000  000       000   000     000     000     
#     0000000  000   000  00000000  000   000     000     00000000

create = (cfg, root = null, inject = null) ->
    #console.log 'ViewTree.create: ', cfg, root
    throwNodeCfgError cfg if isNot cfg
    tag = cfg.tag
    if isSimple(cfg) or (not tag and isSimple(cfg.text))
        clazz = ViewTree.DEFAULT_CLASS
    else
        if isFunc(tag) and (tag.prototype instanceof Node or tag == Node)
            clazz = cfg.tag
        else
            throwNodeCfgError cfg if not isString(tag) or tag == ''
            clazz = tagMap[tag] or ViewTree.DEFAULT_CLASS

    node = createNode clazz, cfg, inject
    createView node, node.render()

    if root != null #TODO: node.render() is called twice in this case - bad!!!
        render(node, root)

    else if false #TODO: check, if we really want this
        if isSimple cfg
            updateText node, cfg
        else
            updateProperties node, cfg

        node.onMount()
    node




#     0000000  00000000   00000000   0000000   000000000  00000000        000   000   0000000   0000000    00000000
#    000       000   000  000       000   000     000     000             0000  000  000   000  000   000  000     
#    000       0000000    0000000   000000000     000     0000000         000 0 000  000   000  000   000  0000000 
#    000       000   000  000       000   000     000     000             000  0000  000   000  000   000  000     
#     0000000  000   000  00000000  000   000     000     00000000        000   000   0000000   0000000    00000000

createNode = (clazz, cfg, inject) ->
    inject = cfg.__i__ or inject
    return new clazz cfg if not inject

    #console.log 'INJECT: ', clazz, inject

    p = clazz.prototype
    m = {}
    for key, value of inject
        m[key] = p[key]
        p[key] = value
        #console.log 'INJECT set value: ', key, value

    node       = new clazz cfg
    node.__i__ = inject
    delete cfg.__i__

    p[key] = m[key] for key of inject
    node




#     0000000  00000000   00000000   0000000   000000000  00000000        000   000  000  00000000  000   000
#    000       000   000  000       000   000     000     000             000   000  000  000       000 0 000
#    000       0000000    0000000   000000000     000     0000000          000 000   000  0000000   000000000
#    000       000   000  000       000   000     000     000                000     000  000       000   000
#     0000000  000   000  00000000  000   000     000     00000000            0      000  00000000  00     00

createView = (node, cfg) ->
    throwViewCfgError(cfg) if isNot cfg
    if isSimple(cfg) or (not cfg.tag and (isSimple(cfg.text) or isFunc(cfg.text)))
        node.tag  = undefined
        node.text = (cfg.text or cfg) + ''
        node.view = document.createTextNode node.text
    else
        throwViewCfgError(cfg) if not isString(tag = cfg.tag) or tag == ''
        node.tag  = tag
        node.view =  document.createElement tag
    node.view




#    00000000   00000000  000   000  0000000    00000000  00000000 
#    000   000  000       0000  000  000   000  000       000   000
#    0000000    0000000   000 0 000  000   000  0000000   0000000  
#    000   000  000       000  0000  000   000  000       000   000
#    000   000  00000000  000   000  0000000    00000000  000   000

render = (node, root) ->
    #console.log 'ViewTree.render: ', node, root
    cfg = node.render()
    if not node.view
        createView node, cfg

    root.appendChild(node.view)

    if isSimple cfg
        updateText node, cfg
    else
        updateProperties node, cfg

    node.onMount()
    null




#    00000000   00000000  00     00   0000000   000   000  00000000
#    000   000  000       000   000  000   000  000   000  000     
#    0000000    0000000   000000000  000   000   000 000   0000000 
#    000   000  000       000 0 000  000   000     000     000     
#    000   000  00000000  000   000   0000000       0      00000000

remove = (nodeOrRoot) ->




#    000   000  00000000   0000000     0000000   000000000  00000000
#    000   000  000   000  000   000  000   000     000     000     
#    000   000  00000000   000   000  000000000     000     0000000 
#    000   000  000        000   000  000   000     000     000     
#     0000000   000        0000000    000   000     000     00000000

update = (node) ->
    id = node?.__id__
    if not id
        throw new Error "DOM ERROR: can't update node. Node doesn't exist. cfg = " + getCfgJson(node?.cfg or null)

    if not dirty
        window.cancelAnimationFrame rafTimeout
        rafTimeout = window.requestAnimationFrame updateNow

    dirtyMap[id] = true
    dirty        = true
    null




#    000   000  00000000   0000000     0000000   000000000  00000000        000   000   0000000   000   000
#    000   000  000   000  000   000  000   000     000     000             0000  000  000   000  000 0 000
#    000   000  00000000   000   000  000000000     000     0000000         000 0 000  000   000  000000000
#    000   000  000        000   000  000   000     000     000             000  0000  000   000  000   000
#     0000000   000        0000000    000   000     000     00000000        000   000   0000000   00     00

updateNow = () ->
    window.cancelAnimationFrame rafTimeout
    dirty = false
    #TODO: sort by depth to update top down
    nodes = []
    (nodes.push(n) if n = nodeMap[id]) for id of dirtyMap
    nodes.sort (a, b) -> a.depth - b.depth
    for node in nodes
        continue if not node
        cfg = node.render()

        if node.tag != cfg.tag
            replaceChild node, cfg
        else
            updateProperties node, cfg
    null




#    000   000  00000000   0000000     0000000   000000000  00000000        000000000  00000000  000   000  000000000
#    000   000  000   000  000   000  000   000     000     000                000     000        000 000      000   
#    000   000  00000000   000   000  000000000     000     0000000            000     0000000     00000       000   
#    000   000  000        000   000  000   000     000     000                000     000        000 000      000   
#     0000000   000        0000000    000   000     000     00000000           000     00000000  000   000     000   

updateText = (node, cfg) ->
    #console.log 'UPDATE TEXT: ', node
    text = (cfg.text or cfg) + ''
    if node.text != text
        node.cfg            = cfg
        node.text           = text
        node.view.nodeValue = text
    null




#    000   000  00000000   0000000     0000000   000000000  00000000        00000000   00000000    0000000   00000000    0000000
#    000   000  000   000  000   000  000   000     000     000             000   000  000   000  000   000  000   000  000     
#    000   000  00000000   000   000  000000000     000     0000000         00000000   0000000    000   000  00000000   0000000 
#    000   000  000        000   000  000   000     000     000             000        000   000  000   000  000             000
#     0000000   000        0000000    000   000     000     00000000        000        000   000   0000000   000        0000000 

updateProperties = (node, cfg) ->
    #console.log 'UPDATE PROPS: ', node
    cfg     = cfg.render() if cfg instanceof Node
    attrs   = node.attrs or node.attrs = {}
    propMap = Object.assign {}, attrs, node.events, cfg

    if propMap.hasOwnProperty 'className'
        updateClass node, cfg.className

    if propMap.hasOwnProperty 'style'
        updateStyle node, cfg.style

    if propMap.hasOwnProperty 'children'
        updateChildren node, cfg.children

    delete propMap.tag
    delete propMap.__i__
    delete propMap.keep
    delete propMap.text
    delete propMap.className
    delete propMap.style
    delete propMap.children
    delete propMap.bindings

    for name of propMap
        attr  = attrs[name]
        value = cfg[name]
        if isBool(attr) or isBool(value)
            updateBool node, value, name
        else
            if /^on/.test name
                updateEvent node, value, name
            else
                value = value() if isFunc value
                updateAttr node, value, name
    null








#     0000000   000000000  000000000  00000000    0000000
#    000   000     000        000     000   000  000
#    000000000     000        000     0000000    0000000
#    000   000     000        000     000   000       000
#    000   000     000        000     000   000  0000000

updateAttr = (node, value, name) ->
    return if node.attrs[name] == value
    if value != null and value != undefined
        node.view.setAttribute name, value
        node.view[name]  = value
        node.attrs[name] = value
    else
        node.view.removeAttribute name
        delete node.view[name]
        delete node.attrs[name]
    null




#    0000000     0000000    0000000   000
#    000   000  000   000  000   000  000
#    0000000    000   000  000   000  000
#    000   000  000   000  000   000  000
#    0000000     0000000    0000000   0000000

updateBool = (node, value, name) ->
    return if node.attrs[name] == value
    view = node.view
    if isNot value
        view.removeAttribute name
        delete node.attrs[name]
    else
        node.attrs[name] = value
        if value
            view.setAttribute name, ''
            view[name] = true
        else
            view.removeAttribute name
            view[name] = false
    null




#     0000000  000       0000000    0000000   0000000
#    000       000      000   000  000       000
#    000       000      000000000  0000000   0000000
#    000       000      000   000       000       000
#     0000000  0000000  000   000  0000000   0000000

updateClass = (node, value) ->
    value = value() if isFunc value

    return if node.attrs.className == value
    if value
        node.view.className  = value
        node.attrs.className = value
    else
        node.view.className  = undefined
        delete node.attrs.className
    null




#     0000000  000000000  000   000  000      00000000
#    000          000      000 000   000      000
#    0000000      000       00000    000      0000000
#         000     000        000     000      000
#    0000000      000        000     0000000  00000000

updateStyle = (node, style) ->
    view  = node.view
    attrs = node.attrs
    sobj  = attrs.style

    style = style() if isFunc style

    if isNot style
        view.style.cssText = null
        delete attrs.style

    else if isString style
        view.style.cssText = style
        attrs.style        = style
    else
        css     = ''
        sobj    = if isObject(sobj) then sobj else {}
        changed = false
        propMap = Object.assign {}, style, sobj
        for name of propMap
            value = style[name]
            if value != sobj[name]
                changed = true
            sobj[name] = value
            if isNot value
                delete sobj[name]
            else
                prop  = normalizeName name
                css  += prop + ': ' + value + '; '

        if changed
            if css.length
                css                = css.slice 0, -1
                view.style.cssText = css
                attrs.style        = sobj
            else
                view.style.cssText = null
                delete attrs.style
    null




#    00000000  000   000  00000000  000   000  000000000   0000000
#    000       000   000  000       0000  000     000     000
#    0000000    000 000   0000000   000 0 000     000     0000000
#    000          000     000       000  0000     000          000
#    00000000      0      00000000  000   000     000     0000000

updateEvent = (node, callback, name) ->
    events    = node.events or node.events = {}
    view      = node.view
    type      = normalizeEvent name
    listener  = events[name]

    if isString callback
        callback = node[name]

    if listener != callback
        if listener
            view.removeEventListener(type, listener)
            delete events[name]
        if callback
            view.addEventListener(type, callback)
            events[name] = callback
    null


removeEvents = (node) ->
    events = node.events
    return null if not events

    view = node.view
    for name, listener of events
        type = normalizeEvent name
        view.removeEventListener(type, listener) if listener
        delete events[name]
    node.events = null
    null




#     0000000  000   000  000  000      0000000    00000000   00000000  000   000
#    000       000   000  000  000      000   000  000   000  000       0000  000
#    000       000000000  000  000      000   000  0000000    0000000   000 0 000
#    000       000   000  000  000      000   000  000   000  000       000  0000
#     0000000  000   000  000  0000000  0000000    000   000  00000000  000   000

updateChildren = (node, cfgs) ->
    children = node.children or node.children = []
    cfgs     = cfgs() if isFunc cfgs
    cfgs     = if isString(cfgs) then [cfgs] else cfgs or []
    l        = if children.length > cfgs.length then children.length else cfgs.length
    for i in [0...l]
        child = children[i]
        cfg   = cfgs[i]
        cfg   = cfg() if isFunc cfg

        if not child and not cfg
            throw new Error "DOM ERROR: either child or cfg at index #{i} must be defined. Got " + child + ', ' + cfg
        if not child
            addChild node, cfg
        else if not cfg
            removeChild child
        else
            change child, cfg
    children.length = cfgs.length
    null




#     0000000  000   000   0000000   000   000   0000000   00000000
#    000       000   000  000   000  0000  000  000        000
#    000       000000000  000000000  000 0 000  000  0000  0000000
#    000       000   000  000   000  000  0000  000   000  000
#     0000000  000   000  000   000  000   000   0000000   00000000

change = (node, cfg) ->
    canUpdate   = node.canUpdate()
    needsUpdate = node.needsUpdate()
    if node == cfg
        if needsUpdate and canUpdate
            updateProperties node, node.render()
        else if needsUpdate and not canUpdate
            replaceChild node, node.render()

        # node don't wants to be updated

    else if node.tag != cfg.tag or cfg instanceof Node
        replaceChild node, cfg

    else if node.tag == undefined # text node
        updateText node, cfg

    else if canUpdate and needsUpdate # tag node
        updateProperties node, cfg

    false




#     0000000   0000000    0000000
#    000   000  000   000  000   000
#    000000000  000   000  000   000
#    000   000  000   000  000   000
#    000   000  0000000    0000000

addChild = (node, cfg) ->
    if cfg instanceof Node
        child = cfg
        cfg   = child.render()
    else
        child = create cfg, null, cfg.__i__ or node.__i__

    if not child.view
        child.view = createView child, cfg

    node.children.push child
    node.view.appendChild child.view
    child.parent = node


    if isSimple(cfg) or (not cfg.tag and isSimple(cfg.text))
        updateText child, cfg
    else
        updateProperties child, cfg

    child.onMount()
    null




#    00000000   00000000  00     00   0000000   000   000  00000000
#    000   000  000       000   000  000   000  000   000  000
#    0000000    0000000   000000000  000   000   000 000   0000000
#    000   000  000       000 0 000  000   000     000     000
#    000   000  00000000  000   000   0000000       0      00000000

removeChild = (child) ->
    #TODO: node.children currently not handled -> handled by changing node.children.length in updateChildren

    #console.log 'removeChild: ', child, node

    node = child.parent
    view = child.view
    disposeNode child
    node.view.removeChild view
    null




#    00000000   00000000  00000000   000       0000000    0000000  00000000
#    000   000  000       000   000  000      000   000  000       000
#    0000000    0000000   00000000   000      000000000  000       0000000
#    000   000  000       000        000      000   000  000       000
#    000   000  00000000  000        0000000  000   000   0000000  00000000

replaceChild = (child, cfg) ->
    consol.log 'ViewTree.replaceChild: ', child, cfg
    node     = child.parent
    children = node.children
    i        = children.indexOf child
    view     = child.view

    disposeNode child

    if cfg instanceof Node
        child = cfg
        cfg   = child.render()
    else
        child = create cfg, null, cfg.__i__ or node.__i__

    if not child.view
        child.view = createView child, cfg

    children[i]  = child
    child.parent = node
    node.view.replaceChild child.view, view

    if isSimple(cfg) or (not cfg.tag and isSimple(cfg.text))
        updateText child, cfg
    else
        updateProperties child, cfg

    child.onMount()
    #console.log 'DOM.replaceChild: create = ', child, cfg
    null




#    0000000    000   0000000  00000000    0000000    0000000  00000000
#    000   000  000  000       000   000  000   000  000       000
#    000   000  000  0000000   00000000   000   000  0000000   0000000
#    000   000  000       000  000        000   000       000  000
#    0000000    000  0000000   000         0000000   0000000   00000000

disposeNode = (node) ->
    #console.log 'disposeNode: ', node
    if node.onUnmount() != true

        console.log 'dispose node now: ', node
        removeEvents node

        if node.children and node.children.length
            disposeNode child for child in node.children

        delete node.children
        delete node.view
        delete nodeMap[node.__id__]

    node.parent = null
    null








#    00000000    0000000   00000000
#    000   000  000   000  000
#    0000000    000000000  000000
#    000   000  000   000  000
#    000   000  000   000  000

if typeof window != 'undefined'
    lastTime = 0
    vendors  = ['webkit', 'moz']
    for vendor in vendors
        break if window.requestAnimationFrame
        window.requestAnimationFrame = window[vendor + 'RequestAnimationFrame']
        window.cancelAnimationFrame  = window[vendor + 'CancelAnimationFrame' ] or window[vendor + 'CancelRequestAnimationFrame']


    if not window.requestAnimationFrame
        window.requestAnimationFrame = (callback) ->
            currTime   = Date.now()
            timeToCall = Math.max 0, 16 - currTime + lastTime
            rAF        = () -> callback currTime + timeToCall
            id         = window.setTimeout rAF, timeToCall
            lastTime   = currTime + timeToCall
            id


    if not window.cancelAnimationFrame
        window.cancelAnimationFrame = (id) ->
            clearTimeout id
            null




#     0000000    0000000   0000000  000   0000000   000   000
#    000   000  000       000       000  000        0000  000
#    000000000  0000000   0000000   000  000  0000  000 0 000
#    000   000       000       000  000  000   000  000  0000
#    000   000  0000000   0000000   000   0000000   000   000

if typeof Object.assign == 'undefined'
    Object.assign = (target, args...) ->
        for src in args
            for key of src
                target[key] = src[key];
        target








ViewTree =
    Node:             Node
    DEFAULT_CLASS:    Node
    HANDLE_CTX:       true
    HANDLE_DATA_TREE: true
    COMP_CFG_ERROR:   COMP_CFG_ERROR
    VIEW_CFG_ERROR:   VIEW_CFG_ERROR
    map:              map
    unmap:            unmap
    create:           create
    render:           render
    remove:           remove
    update:           update
    updateNow:        updateNow




if typeof module != 'undefined'
    module.exports = ViewTree
if typeof window != 'undefined'
    window.ViewTree = ViewTree
else
    this.ViewTree = ViewTree