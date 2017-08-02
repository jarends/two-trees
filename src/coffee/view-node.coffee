__id__ = 0


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




###
    cfg as string || boolean || number
        node is a text node

    cfg as object
        tag can be
            string
                which is mapped to an component class
                the node name
            node class
            node instance

    cfg as node instance # invalid in create

    cfg as func


    cfg =
        tag:
        text:
        style:
        bind
        clazz:
        child:
        children:
        event handlers starting with 'on', camel case converts to kebab case


    update:

        if value == undefined -> no update
        if value == null      -> remove value
        else                  -> update

###





class ViewNode


    @DEBUG         = true
    @CHECK_DOM     = true
    @DEFAULT_CLASS = @



    constructor: (cfg) ->
        @register cfg
        @updateCfg cfg
        @updateNow()


    register: (@cfg) ->
        @parent = null
        @depth  = 0
        @keep   = false
        if not @__id__
            @__id__ = ++__id__
            nodeMap[@__id__] = @
        @__id__
        injectNode @, @cfg


    updateNow: (cfg) ->
        cfg = cfg or @render()
        createView @, cfg if isNot @view
        if isSimple(cfg) or (not cfg.tag and (isSimple(cfg.text) or isFunc(cfg.text)))
            updateText @, cfg
        else
            updateProperties @, cfg
        @


    # add nodes view to dom
    appendTo: (dom) -> append  @, dom
    behind:   (dom) -> behind  @, dom
    before:   (dom) -> before  @, dom
    replace:  (dom) -> replace @, dom
    remove:   (dom) -> replace @, dom


    dispose: () -> null


    onMount: () -> null


    onUnmount: () -> @keep


    updateCfg:   (cfg) -> (@cfg = cfg) or true
    update:      () => update @
    render:      () -> @cfg


    onAdded:   () ->


    onRemoved: () ->


    addChild:       (child) ->
    addChildAt:     (child, index) ->
    removeChild:    (child) ->
    removeChildAt:  (index) ->




#    00000000   00000000    0000000   00000000    0000000
#    000   000  000   000  000   000  000   000  000     
#    00000000   0000000    000   000  00000000   0000000 
#    000        000   000  000   000  000             000
#    000        000   000   0000000   000        0000000 

classMap   = {}
nodeMap    = {}
dirtyMap   = {}
cleanMap   = {}
domList    = []
dirty      = false
rafTimeout = null




#    00     00   0000000   00000000 
#    000   000  000   000  000   000
#    000000000  000000000  00000000 
#    000 0 000  000   000  000      
#    000   000  000   000  000      

map = (tag, clazz, overwrite = false) ->
    if isNot(classMap[tag]) or overwrite
        classMap[tag] = clazz
    null





#    000   000  000   000  00     00   0000000   00000000 
#    000   000  0000  000  000   000  000   000  000   000
#    000   000  000 0 000  000000000  000000000  00000000 
#    000   000  000  0000  000 0 000  000   000  000      
#     0000000   000   000  000   000  000   000  000      

unmap = (tag) ->
    delete classMap[tag]
    null




#     0000000  00000000   00000000   0000000   000000000  00000000
#    000       000   000  000       000   000     000     000     
#    000       0000000    0000000   000000000     000     0000000 
#    000       000   000  000       000   000     000     000     
#     0000000  000   000  00000000  000   000     000     00000000

create = (cfg, root = null) ->
    if isNot cfg
        throw new Error "A node can't be created from empty cfg."
        
    if not extendsNode clazz = cfg.clazz
        if not extendsNode clazz = cfg.tag
            clazz = null
            tag   = cfg.nodeName.toLowerCase() if isDom cfg
            clazz = classMap[tag] if isString tag = tag or cfg.tag

    clazz = clazz or ViewNode.DEFAULT_CLASS
    node  = new clazz cfg

    if root != null #TODO: node.render() is called twice in this case - bad!!!
        render(node, root)
    node




#    000  000   000        000  00000000   0000000  000000000        000   000   0000000   0000000    00000000
#    000  0000  000        000  000       000          000           0000  000  000   000  000   000  000     
#    000  000 0 000        000  0000000   000          000           000 0 000  000   000  000   000  0000000 
#    000  000  0000  000   000  000       000          000           000  0000  000   000  000   000  000     
#    000  000   000   0000000   00000000   0000000     000           000   000   0000000   0000000    00000000

injectNode = (node, cfg) ->
    if isNot(node.__i__) and cfg and cfg.__i__
        inject    = node.__i__ = cfg.__i__
        node[key] = value for key, value of inject
    node




#     0000000  00000000   00000000   0000000   000000000  00000000        000   000  000  00000000  000   000
#    000       000   000  000       000   000     000     000             000   000  000  000       000 0 000
#    000       0000000    0000000   000000000     000     0000000          000 000   000  0000000   000000000
#    000       000   000  000       000   000     000     000                000     000  000       000   000
#     0000000  000   000  00000000  000   000     000     00000000            0      000  00000000  00     00

createView = (node, cfg) ->
    if node.view
        throw new Error "View already exists"
    if isNot cfg = node.render()
        throw new Error "A view for an empty cfg can't be created."
    switch true
        when isSimple  cfg then createTextView    node, node.cfg = text: cfg + ''
        when isDom     cfg then createTagFromDom  node, null, cfg
        when isDomText cfg then createTextFromDom node, null, cfg
        else
            tag = cfg.tag
            switch true
                when isNot     tag then createTextView    node, cfg
                when isString  tag then createTagView     node, cfg
                when isDom     tag then createTagFromDom  node, cfg, tag
                when isDomText tag then createTextFromDom node, cfg, tag
                else
                    if extendsNode tag
                        throw new Error "A tag must be a string or a HTMLElement, you specified a ViewNode class."
                    throw new Error "A tag must be a string or a HTMLElement."

    domList.push node.view if ViewNode.CHECK_DOM
    node




createTextView = (node, cfg) ->
    text = cfg.text
    text = text() if isFunc text
    if not isSimple text
        throw new Error "The text for a text node must be a string, number or bool."
    node.text = text
    node.tag  = cfg.tag  = null
    node.kind = ViewNode.TEXT_KIND
    node.view = document.createTextNode text


createTextFromDom = (node, cfg, dom) ->
    checkDom dom if ViewNode.CHECK_DOM
    node.text = dom.nodeValue
    node.tag  = null
    node.kind = ViewNode.TEXT_KIND
    node.view = dom
    if cfg
        text = cfg.text
        if isNot text
            cfg.text = node.text
        else
            text = text() if isFunc text
            if not isSimple text
                throw new Error "The text for a text node must be a string, number or bool."
            node.text = dom.nodeValue = text
    else
        cfg = node.cfg = text: node.text
    cfg.tag = null
    node


createTagView = (node, cfg) ->
    node.tag  = tag = cfg.tag
    node.kind = ViewNode.TAG_KIND
    node.view = document.createElement tag
    node


createTagFromDom = (node, cfg, dom) ->
    checkDom dom if ViewNode.CHECK_DOM
    node.tag  = dom.nodeName.toLowerCase()
    node.kind = ViewNode.TAG_KIND
    node.view = dom
    cfg       = cfg or node.cfg = {}
    cfg.tag   = node.tag
    node



#    00000000   00000000  000   000  0000000    00000000  00000000 
#    000   000  000       0000  000  000   000  000       000   000
#    0000000    0000000   000 0 000  000   000  0000000   0000000  
#    000   000  000       000  0000  000   000  000       000   000
#    000   000  00000000  000   000  0000000    00000000  000   000

render = (node, root) ->
    cfg = node.render()
    if not node.view
        createView node, cfg

    root.appendChild(node.view)
    node.updateNow()
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
    #console.log 'UPDATE: ', node.__id__
    id = node?.__id__
    if not id
        throw new Error "Can't update node. ViewNode doesn't exist."

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
    #console.log 'UPDATE NOW: '
    window.cancelAnimationFrame rafTimeout
    dirty    = false
    cleanMap = {}
    nodes    = []
    #TODO: sort by depth to update top down
    (nodes.push(n) if n = nodeMap[id]) for id of dirtyMap
    nodes.sort (a, b) -> a.depth - b.depth
    for node in nodes
        continue if not node.view or not nodeMap[node.__id__] or cleanMap[node.__id__]
        cfg = node.render()

        #if node.constructor.name == 'Check'
        #console.log 'update node now: ', node.constructor.name, node.depth, node.__id__, node.view, cleanMap

        if isNot(node.tag) and isNot(cfg.tag)
            updateText node, cfg
        else if not (node.tag == cfg.tag or node.constructor == cfg.tag)
            replaceChild node, cfg
        else
            updateProperties node, cfg
    dirtyMap = {}
    null




#    000   000  00000000   0000000     0000000   000000000  00000000        000000000  00000000  000   000  000000000
#    000   000  000   000  000   000  000   000     000     000                000     000        000 000      000   
#    000   000  00000000   000   000  000000000     000     0000000            000     0000000     00000       000   
#    000   000  000        000   000  000   000     000     000                000     000        000 000      000   
#     0000000   000        0000000    000   000     000     00000000           000     00000000  000   000     000   

updateText = (node, cfg) ->
    cleanMap[node.__id__] = true
    text = if isFunc(cfg.text) then cfg.text() else if isString(cfg) then cfg else cfg.text
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
    cleanMap[node.__id__] = true
    #console.log 'UPDATE PROPS: ', node.__id__, node.view

    cfg     = cfg.render() if cfg instanceof ViewNode
    attrs   = node.attrs or node.attrs = {}
    propMap = Object.assign {}, attrs, node.events, cfg

    if propMap.hasOwnProperty 'className'
        updateClass node, cfg.className

    if propMap.hasOwnProperty 'style'
        updateStyle node, cfg.style

    if propMap.hasOwnProperty 'text'
        text = text() if isFunc text = cfg.text
        if isSimple text
            updateChildren node, [text]
        else if isDomText text
            updateChildren node, [text]

        if ViewNode.DEBUG
            if cfg.hasOwnProperty 'child'
                console.warn 'child specified while text exists: ', cfg
            if cfg.hasOwnProperty 'children'
                console.warn 'children specified while text exists', cfg

    else if propMap.hasOwnProperty 'child'
        child = child() if isFunc child = cfg.child
        updateChildren node, [child]

        if ViewNode.DEBUG
            if cfg.hasOwnProperty 'children'
                console.warn 'children specified while text exists', cfg

    else if propMap.hasOwnProperty 'children'
        updateChildren node, cfg.children

    delete propMap.tag
    delete propMap.clazz
    delete propMap.__i__
    delete propMap.keep
    delete propMap.text
    delete propMap.child
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
    null








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

    needsUpdate = node.updateCfg cfg
    if node == cfg or node.constructor == cfg.tag
        updateProperties node, node.render() if needsUpdate

    else if node.tag != cfg.tag or cfg instanceof ViewNode
        replaceChild node, cfg

    else if isNot node.tag        # text node
        updateText node, cfg

    else if needsUpdate           # tag node
        updateProperties node, cfg

    false




#     0000000   0000000    0000000
#    000   000  000   000  000   000
#    000000000  000   000  000   000
#    000   000  000   000  000   000
#    000   000  0000000    0000000

addChild = (node, cfg) ->
    if cfg instanceof ViewNode
        child = cfg
    else
        cfg.__i__ = node.__i__ if not cfg.__i__
        child = create cfg

    node.children.push child
    node.view.appendChild child.view
    child.parent = node
    child.depth  = node.depth + 1
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
    node     = child.parent
    children = node.children
    i        = children.indexOf child
    view     = child.view

    disposeNode child

    if cfg instanceof ViewNode
        child = cfg
        cfg   = child.render()
    else
        cfg.__i__ = node.__i__ if not cfg.__i__
        child = create cfg

    children[i]  = child
    child.parent = node
    child.depth  = node.depth + 1
    node.view.replaceChild child.view, view

    if isSimple(cfg) or (not cfg.tag and (isSimple(cfg.text) or isFunc(cfg.text)))
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




checkDom = (dom) ->
    if domList.indexOf(dom) > -1
        throw new Error 'Dom element already controlled by another node.'


append = (node, dom) ->
    checkDom dom if ViewNode.CHECK_DOM
    dom.appendChild node.view



behind = (node, dom) ->
    parent = dom.parentNode
    next   = dom.nextSibling
    checkDom parent if ViewNode.CHECK_DOM
    if next
        parent.insertBefore node.view, next
    else
        parent.appendChild node.view


before = (node, dom) ->
    parent = dom.parentNode
    checkDom parent if ViewNode.CHECK_DOM
    parent.insertBefore node.view, dom


replace = (node, dom) ->
    parent = dom.parentNode
    if ViewNode.CHECK_DOM
        checkDom parent
        checkDom dom
    parent.replaceChild node.view, dom


remove = (node) ->
    parent = node.view.parentNode
    checkDom parent if ViewNode.CHECK_DOM
    parent.removeChild node.view








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




ViewNode.create      = create
ViewNode.map         = map
ViewNode.unmap       = unmap

ViewNode.append      = append
ViewNode.behind      = behind
ViewNode.before      = before
ViewNode.replace     = replace
ViewNode.remove      = remove

ViewNode.getOrCall   = getOrCall
ViewNode.isBool      = isBool
ViewNode.isNumber    = isNumber
ViewNode.isString    = isString
ViewNode.isObject    = isObject
ViewNode.isFunc      = isFunc
ViewNode.isDom       = isDom
ViewNode.isDomText   = isDomText
ViewNode.isNot       = isNot
ViewNode.isSimple    = isSimple
ViewNode.extendsNode = extendsNode






if typeof module != 'undefined'
    module.exports = ViewNode
if typeof window != 'undefined'
    window.ViewNode = ViewNode
else
    this.ViewNode = ViewNode