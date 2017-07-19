__id__ = 0


isBool   = (value) -> typeof value == 'boolean'
isNumber = (value) -> typeof value == 'number'
isString = (value) -> typeof value == 'string' or value == value + ''
isObject = (value) -> typeof value == 'object'
isFunc   = (value) -> typeof value == 'function'
isHTML   = (value) -> value instanceof HTMLElement
isNot    = (value) -> value == null or value == undefined
isSimple = (value) ->
    t = typeof value
    t == 'string' or t == 'number' or t == 'boolean' or value == value + '' or value == true or value == false or not isNaN value




normalizeName = (name) ->
    name.replace /[A-Z]/g, (name) ->
        '-' + name.toLowerCase()




normalizeEvent = (type) ->
    type = type.slice 2
    type.charAt(0).toLowerCase() + normalizeName type.slice(1)




throwCfgError = (cfg) ->
    throw new Error 'TreeOne ERROR: cfg must be either a string or an object containing a tag property as string. cfg = ' + getCfgJson cfg




getCfgJson = (cfg) ->
    try
        c = JSON.stringify cfg
    catch
    c + ''




###
    cfg =
        tag:
        style:
        className:
        children:
        event handlers starting with 'on'

###





class Node


    constructor: (@cfg) ->
        nodeMap[@id = ++__id__] = @


    dispose: () ->
        if @children and @children.length
            child.dipose() for child in @children
        delete nodeMap[@id]
        null


    onMount:   () ->
        if @children and @children.length
            child.onMount() for child in @children
        null


    onUnmount: () ->
        if @children and @children.length
            child.onUnmount() for child in @children
        null


    needsUpdate: () -> true
    canUpdate:   () -> true
    update:      () -> update @
    render:      () -> @cfg


    onAdded:   () ->
        if @children and @children.length
            child.onAdded() for child in @children


    onRemoved: () ->
        if @children and @children.length
            child.onRemoved() for child in @children


    add:       (child) ->
    addAt:     (child, index) ->
    remove:    (child) ->
    removeAt:  (index) ->






tagMap     = {}
rootMap    = {}
nodeMap    = {}
dirtyMap   = {}
dirty      = false
rafTimeout = null



map = (tag, clazz, overwrite = false) ->
    if isNot(tagMap[tag]) or overwrite
        tagMap[tag] = clazz
    null




unmap = (tag) ->
    delete tagMap[tag]
    null




create = (cfg, root = null) ->
    #console.log 'TreeOne.create: ', cfg, root
    throwCfgError(cfg) if isNot cfg
    if isSimple cfg
        clazz = Node
    else
        throwCfgError(cfg) if not isString cfg.tag
        clazz = tagMap[cfg.tag] or Node

    node      = new clazz cfg
    node.view = createView node.render(), node
    render(node, root) if root != null
    node




render = (node, root) ->
    #console.log 'TreeOne.render: ', node, root
    cfg = node.render()
    if not node.view
        node.view = createView cfg, node

    root.appendChild(node.view)

    if isSimple cfg
        updateText node, cfg
    else
        updateProperties node, cfg
    null




remove = (nodeOrRoot) ->




update = (node) ->
    id = node?.id
    if not id
        throw new Error "DOM ERROR: can't update node. Node doesn't exist. cfg = " + getCfgJson(node?.cfg or null)
        return

    if not dirty
        window.cancelAnimationFrame rafTimeout
        rafTimeout = window.requestAnimationFrame updateNow

    dirtyMap[id] = true
    dirty        = true
    null




updateNow = () ->
    window.cancelAnimationFrame rafTimeout
    dirty = false
    #TODO: sort by depth to update top down
    nodes = []
    nodes.push(nodeMap[id]) for id of dirtyMap
    nodes.sort (a, b) -> a.depth - b.depth
    for node in nodes
        continue if not node
        delete dirtyMap[node.id]
        cfg = node.render()
        #TODO: This removes a component if the kind swaps between text and tag or between different tags. Maybe we can keep the component somehow!!!
        #TODO: Maybe ask the component, if it wants to be updated or replaced (like change method does)
        #TODO: We definitly want to keep the component!!!
        if node.tag != cfg.tag
            replaceChild node, cfg
        else
            updateProperties node, cfg
    null





createView = (cfg, node) ->
    throwCfgError(cfg) if isNot cfg
    if isSimple cfg
        node.tag = undefined
        return document.createTextNode(cfg + '')
    throwCfgError(cfg) if not isString tag = cfg.tag
    node.tag = tag
    document.createElement tag




updateText = (node, cfg) ->
    if node.cfg != cfg
        node.cfg            = cfg
        node.view.nodeValue = cfg + ''
    null




updateProperties = (node, cfg) ->
    attrs   = node.attrs or node.attrs = {}
    propMap = Object.assign {}, node.attrs, node.events, cfg
    delete propMap.tag
    delete propMap.children
    delete propMap.style
    delete propMap.className

    for name of propMap
        attr  = attrs[name]
        value = cfg[name]
        if isBool(attr) or isBool(value)
            updateBool node, value, name
        else
            if /^on/.test name
                updateEvent node, value, name
            else
                updateAttr node, value, name

    if attrs.className or cfg.className
        updateClass node, value

    if attrs.style or cfg.style
        updateStyle node, cfg.style

    if attrs.children or cfg.children
        updateChildren node, cfg.children

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




#     0000000  000       0000000    0000000   0000000
#    000       000      000   000  000       000
#    000       000      000000000  0000000   0000000
#    000       000      000   000       000       000
#     0000000  0000000  000   000  0000000   0000000

updateClass = (node, value) ->
    return if node.attrs.className == value
    if value
        node.view.setAttribute 'class', value
        node.attrs.className = value
    else
        node.view.removeAttribute 'class'
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
    cfgs     = if isString(cfgs) then [cfgs] else cfgs or []
    l        = if children.length > cfgs.length then children.length else cfgs.length
    for i in [0...l]
        child = children[i]
        cfg   = cfgs[i]

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
    if node == cfg
        if node.canUpdate() and node.needsUpdate()
            updateProperties node, cfg
        else
            replaceChild node, cfg

    else if node.tag != cfg.tag
        replaceChild node, cfg

    else if node.tag == undefined # text node
        updateText node, cfg

    else if node.canUpdate() and node.needsUpdate()
        updateProperties node, cfg

    false




#     0000000   0000000    0000000
#    000   000  000   000  000   000
#    000000000  000   000  000   000
#    000   000  000   000  000   000
#    000   000  0000000    0000000

addChild = (node, cfg) ->
    if cfg instanceof Node
        child = node
    else
        child = create cfg

    if not child.view
        child.view = createView cfg, child

    node.children.push child
    node.view.appendChild child.view
    child.parent = node
    if isSimple cfg
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
    node = child.parent
    disposeNode child
    node.view.removeChild child.view
    null




#    00000000   00000000  00000000   000       0000000    0000000  00000000
#    000   000  000       000   000  000      000   000  000       000
#    0000000    0000000   00000000   000      000000000  000       0000000
#    000   000  000       000        000      000   000  000       000
#    000   000  00000000  000        0000000  000   000   0000000  00000000

replaceChild = (child, cfg) ->
    consol.log 'TreeOne.replaceChild: ', child, cfg
    node     = child.parent
    children = node.children
    i        = children.indexOf child
    view     = child.view

    disposeNode child

    if cfg instanceof Node
        child = cfg
    else
        child = create cfg

    if not child.view
        child.view = createView cfg, child

    children[i]  = child
    child.parent = node
    node.view.replaceChild child.view, view

    if isSimple cfg
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
    delete nodeMap[node.id]

    removeEvents node

    if node.children and node.children.length
        disposeNode(child) for child in node.children

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
            currTime   = new Date().getTime()
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








TreeOne =
    Node:      Node
    map:       map
    unmap:     unmap
    create:    create
    render:    render
    remove:    remove
    update:    update
    updateNow: updateNow



if typeof module != 'undefined'
    module.exports = TreeOne
if typeof window != 'undefined'
    window.TreeOne = TreeOne
else
    this.TreeOne = TreeOne