###
    cfg as string || boolean || number
        node is a text node

    cfg as object
        tag can be
            string
                which is mapped to an component class
                the node name
            HTMLElement
            node class    -> render only
            node instance -> render only
            undefined/null if text is defined

    cfg as node instance # invalid in create

    cfg as HTMLElement -> in constructor only

    cfg as func -> has to return a valid node cfg


    cfg =
        tag:
        clazz:
        bind:
        inject:
        text:
        className:
        style:
        child:
        children:
        event handlers starting with 'on', camel case converts to kebab case




    update:

        if value == undefined -> no update
        if value == null      -> remove value
        else                  -> update

###




#    000   000  000000000  000  000       0000000
#    000   000     000     000  000      000     
#    000   000     000     000  000      0000000 
#    000   000     000     000  000           000
#     0000000      000     000  0000000  0000000 

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
extendsNode = (value) -> isFunc(value) and ((value.prototype instanceof Node) or value == Node)


normalizeName = (name) ->
    name.replace /[A-Z]/g, (name) ->
        '-' + name.toLowerCase()


normalizeEvent = (type) ->
    type = type.slice 2
    type.charAt(0).toLowerCase() + normalizeName type.slice(1)




#    000   000   0000000   0000000    00000000
#    0000  000  000   000  000   000  000
#    000 0 000  000   000  000   000  0000000
#    000  0000  000   000  000   000  000
#    000   000   0000000   0000000    00000000

class Node


    @DEFAULT_CLASS = @
    @CHECK_DOM     = true
    @TEXT_KIND     = 0
    @TAG_KIND      = 1


    constructor: (@cfg) ->
        @__id__          = ++__id__
        nodeMap[@__id__] = @
        @keep  = @keep  == true or false
        @valid = @valid == true or false
        @init()

    # internal node configuration
    init: () -> init @

    # add nodes view to dom
    appendTo: (dom) -> append  @, dom
    behind:   (dom) -> behind  @, dom
    before:   (dom) -> before  @, dom
    replace:  (dom) -> replace @, dom

    # remove nodes view from dom
    remove: () -> remove  @

    # direct dom manipulation
    addChild:      (child)        -> addChild      @, child
    addChildAt:    (child, index) -> addChildAt    @, child, index
    removeChild:   (child)        -> removeChild   @, child
    removeChildAt: (index)        -> removeChildAt @, index
    updateNow:     ()             -> updateNow     @
    updateKeyNow:  (name, value)  -> updateKeyNow  @, name, value

    # raf timed dom manipulation
    update:    ()            -> update    @
    updateKey: (name, value) -> updateKey @, name, value

    # override
    render: () -> @cfg

    # override
    dispose: () ->

    clone: () -> clone @

    # callbacks

    # node added to parent
    onAdded: () ->

    # node removed from parent
    onRemoved: () ->

    # nodes view added to dom
    onMount: () ->

    # nodes view removed from dom
    onUnmount: () -> @keep

    # nodes view  was updated
    onUpdated: () ->

    # a key on nodes view was updated
    onKeyUpdated: () ->




#    000000000  00000000   00000000  00000000
#       000     000   000  000       000     
#       000     0000000    0000000   0000000 
#       000     000   000  000       000     
#       000     000   000  00000000  00000000


__id__   = 0
classMap = {}
domList  = []
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
    if classMap[tag] and not overwrite
        throw new Error "A class is already mapped for tag #{tag}."
    classMap[tag] = clazz



    
unmap = (tag) ->
    delete classMap[tag]




#     0000000  00000000   00000000   0000000   000000000  00000000
#    000       000   000  000       000   000     000     000     
#    000       0000000    0000000   000000000     000     0000000 
#    000       000   000  000       000   000     000     000     
#     0000000  000   000  00000000  000   000     000     00000000

create = (cfg) ->
    if isNot cfg
        throw new Error "A node can't be created from empty cfg."
    if not extendsNode clazz = cfg.clazz
        if not extendsNode clazz = cfg.tag
            clazz = null
            tag   = cfg.nodeName.toLowerCase() if isDom cfg
            clazz = classMap[tag] if isString tag = tag or cfg.tag
    clazz = clazz or Node.DEFAULT_CLASS
    new clazz cfg




#    000  000   000  000  000000000
#    000  0000  000  000     000   
#    000  000 0 000  000     000   
#    000  000  0000  000     000   
#    000  000   000  000     000   

init = (node) ->
    if isNot cfg = node.render()
        throw new Error "A node can't be initialized with empty cfg."
    switch true
        when isSimple  cfg then initTextNode    node, node.cfg = text: cfg + ''
        when isDom     cfg then initTagFromDom  node, null, cfg
        when isDomText cfg then initTextFromDom node, null, cfg
        else
            tag = cfg.tag
            switch true
                when isNot     tag then initTextNode    node, cfg
                when isString  tag then initTagNode     node, cfg
                when isDom     tag then initTagFromDom  node, cfg, tag
                when isDomText tag then initTextFromDom node, cfg, tag
                else
                    if extendsNode tag
                        throw new Error "A tag must be a string or a HTMLElement, you specified a Node class."
                    throw new Error "A tag must be a string or a HTMLElement."
    node




initTextNode = (node, cfg) ->
    text = cfg.text
    text = text() if isFunc text
    if not isSimple text
        throw new Error "The text for a text node must be a string, number or bool."
    node.text = text
    node.tag  = cfg.tag  = null
    node.kind = Node.TEXT_KIND
    node.view = document.createTextNode text
    node




initTagNode = (node, cfg) ->
    node.tag  = tag = cfg.tag
    node.kind = Node.TAG_KIND
    node.view = document.createElement tag
    updateProps node, cfg
    node




initTextFromDom = (node, cfg, dom) ->
    checkDom dom if Node.CHECK_DOM
    node.text = dom.nodeValue
    node.tag  = null
    node.kind = Node.TEXT_KIND
    node.view = dom
    if cfg
        text = cfg.text
        if not isNot text
            text = text() if isFunc text
            if not isSimple text
                throw new Error "The text for a text node must be a string, number or bool."
            node.text = dom.nodeValue = text
        else
            cfg.text = node.text
    else
        node.cfg = text: node.text
    node




initTagFromDom = (node, cfg, dom) ->
    checkDom dom if Node.CHECK_DOM
    node.tag  = dom.nodeName.toLowerCase()
    node.kind = Node.TAG_KIND
    node.view = dom
    if cfg and isString(cfg.tag) and cfg.tag != node.tag
        throw new Error "A cfg and the dom element must have the same tag. Got #{cfg.tag} and #{node.tag}"
    cfg     = cfg or node.cfg = {}
    cfg.tag = node.tag
    updateProps node, cfg
    node




#     0000000  000   000  00000000   0000000  000   000        0000000     0000000   00     00
#    000       000   000  000       000       000  000         000   000  000   000  000   000
#    000       000000000  0000000   000       0000000          000   000  000   000  000000000
#    000       000   000  000       000       000  000         000   000  000   000  000 0 000
#     0000000  000   000  00000000   0000000  000   000        0000000     0000000   000   000

checkDom = (dom) ->
    if domList.indexOf(dom) > -1
        throw new Error 'Dom element already controlled by another node.'
    domList.push dom




#    00000000   00000000  00000000   00000000   0000000   00000000   00     00
#    000   000  000       000   000  000       000   000  000   000  000   000
#    00000000   0000000   0000000    000000    000   000  0000000    000000000
#    000        000       000   000  000       000   000  000   000  000 0 000
#    000        00000000  000   000  000        0000000   000   000  000   000

performUpdate = () ->




#    000   000  00000000   0000000     0000000   000000000  00000000
#    000   000  000   000  000   000  000   000     000     000     
#    000   000  00000000   000   000  000000000     000     0000000 
#    000   000  000        000   000  000   000     000     000     
#     0000000   000        0000000    000   000     000     00000000

update = (node) ->




updateKey = (node, name, value) ->




updateNow = (node) ->
    cfg = node.render()




updateKeyNow = (node, name, value) ->




updateText = (node, cfg) ->
    text = cfg.text
    if not isNot text
        text = text() if isFunc text
        if not isSimple text
            throw new Error "The text for a text node must be a string, number or bool."
    else
        cfg.text = node.text





updateProps = (node, cfg) ->
    #console.log 'updateProps: ', node, cfg
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
    delete propMap.clazz
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

        if isBool(value) or (isNot(value) and isBool(attr))
            updateBool node, value, name
        else
            if /^on/.test name
                updateEvent node, value, name
            else
                value = value() if isFunc value
                if isBool value
                    updateBool node, value, name
                else
                    updateAttr node, value, name
    node








#     0000000   000000000  000000000  00000000    0000000
#    000   000     000        000     000   000  000
#    000000000     000        000     0000000    0000000
#    000   000     000        000     000   000       000
#    000   000     000        000     000   000  0000000

updateAttr = (node, value, name) ->
    #console.log 'updateAttr: ', name, value, node.attrs[name], node.__id__
    node.attrs[name] = node.view.getAttribute name
    return if node.attrs[name] == value
    view = node.view
    if value != null and value != undefined
        view.setAttribute name, value
        view[name]       = value
        node.attrs[name] = value
    else
        view.removeAttribute name
        delete view[name]
        delete node.attrs[name]
    null




#    0000000     0000000    0000000   000
#    000   000  000   000  000   000  000
#    0000000    000   000  000   000  000
#    000   000  000   000  000   000  000
#    0000000     0000000    0000000   0000000

updateBool = (node, value, name) ->
    node.attrs[name] = node.view[name]
    return if node.attrs[name] == value
    view = node.view
    if isNot value
        view.removeAttribute name
        view[name] = false
        delete node.attrs[name]
    else if  value == false
        view.removeAttribute name
        view[name]       = false
        node.attrs[name] = false
    else
        view.setAttribute name, ''
        view[name]       = true
        node.attrs[name] = true
    null




#     0000000  000       0000000    0000000   0000000
#    000       000      000   000  000       000
#    000       000      000000000  0000000   0000000
#    000       000      000   000       000       000
#     0000000  0000000  000   000  0000000   0000000

updateClass = (node, value) ->
    value = value() if isFunc value

    node.attrs.className = node.view.className
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

    return if not view

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
    #TODO: allow object as only child
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
    needsUpdate = node.needsUpdate()
    canUpdate   = node.canUpdate(cfg)
    if node == cfg or node.constructor == cfg.tag
        updateProperties node, node.render() if needsUpdate and canUpdate
        replaceChild     node, node.render() if needsUpdate and not canUpdate

        # node don't wants to be updated

    else if node.tag != cfg.tag or cfg instanceof Node
        replaceChild node, cfg

    else if node.tag == undefined # text node
        updateText node, cfg

    else if needsUpdate and canUpdate # tag node
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
    else
        child = create cfg, null, cfg.__i__ or node.__i__

    cfg = child.render()
    if not child.view
        child.view = createView child, cfg

    node.children.push child
    node.view.appendChild child.view
    child.parent = node
    child.depth  = node.depth + 1

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
    #console.log 'ViewTree.replaceChild: ', child, cfg
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

    cfg = child.render()
    if not child.view
        child.view = createView child, cfg

    children[i]  = child
    child.parent = node
    child.depth  = node.depth + 1
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

        #console.log 'dispose node now: ', node
        removeEvents node

        if node.children and node.children.length
            disposeNode child for child in node.children

        delete node.children
        delete node.view
        delete nodeMap[node.__id__]

    node.parent = null
    node.depth  = undefined
    null


append = (node, dom) ->
    checkDom dom if Node.CHECK_DOM
    dom.appendChild node.view


behind        = (node, dom) ->
before        = (node, dom) ->
replace       = (node, dom) ->
remove        = (node) ->
addChild      = (node, child) ->
addChildAt    = (node, child, index) ->
removeChild   = (node, index) ->
removeChildAt = (node, index) ->
disposeNode   = () ->
clone         = () ->








#     0000000  000000000   0000000   000000000  000   0000000
#    000          000     000   000     000     000  000     
#    0000000      000     000000000     000     000  000     
#         000     000     000   000     000     000  000     
#    0000000      000     000   000     000     000   0000000

Node.create      = create
Node.map         = map
Node.unmap       = unmap

Node.append      = append
Node.behind      = behind
Node.before      = before
Node.replace     = replace
Node.remove      = remove

Node.getOrCall   = getOrCall
Node.isBool      = isBool
Node.isNumber    = isNumber
Node.isString    = isString
Node.isObject    = isObject
Node.isFunc      = isFunc
Node.isDom       = isDom
Node.isDomText   = isDomText
Node.isNot       = isNot
Node.isSimple    = isSimple
Node.extendsNode = extendsNode








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




#    00000000  000   000  00000000    0000000   00000000   000000000
#    000        000 000   000   000  000   000  000   000     000   
#    0000000     00000    00000000   000   000  0000000       000   
#    000        000 000   000        000   000  000   000     000   
#    00000000  000   000  000         0000000   000   000     000   

if typeof module != 'undefined'
    module.exports = Node
if typeof window != 'undefined'
    window.Node = Node
else
    this.Node = Node
