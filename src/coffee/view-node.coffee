_          = require './utils'
__id__     = 0
nodeMap    = {}
dirtyMap   = {}
classMap   = {}
domList    = []
dirty      = false
rafTimeout = null




#    000   000  000  00000000  000   000          000   000   0000000   0000000    00000000
#    000   000  000  000       000 0 000          0000  000  000   000  000   000  000     
#     000 000   000  0000000   000000000  000000  000 0 000  000   000  000   000  0000000 
#       000     000  000       000   000          000  0000  000   000  000   000  000     
#        0      000  00000000  00     00          000   000   0000000   0000000    00000000

class ViewNode


    @DEBUG         = false
    @DEFAULT_CLASS = ViewNode
    @CHECK_DOM     = false
    @TAG_KIND      = 1
    @TEXT_KIND     = 3
    @IGNORES       =
        tag:       true
        clazz:     true
        inject:    true
        keep:      true
        text:      true
        child:     true
        className: true
        style:     true
        children:  true
        bindings:  true




    constructor: (cfg) ->
        @parent = null
        @depth  = 0
        @keep   = cfg?.keep ? false;
        @__id__ = ++__id__
        nodeMap[@__id__] = @
        if cfg and cfg.inject
            @inject = cfg.inject
            @[key] = value for key, value of @inject
        @init      cfg
        @updateCfg cfg
        @populate()




    #    00000000   00000000   0000000   000            0000000     0000000   00     00
    #    000   000  000       000   000  000            000   000  000   000  000   000
    #    0000000    0000000   000000000  000            000   000  000   000  000000000
    #    000   000  000       000   000  000            000   000  000   000  000 0 000
    #    000   000  00000000  000   000  0000000        0000000     0000000   000   000

    appendTo: (dom) ->
        if @parent
            throw new Error 'Please remove node from parent node before adding to the real dom.'
        checkDom dom if ViewNode.CHECK_DOM
        dom.appendChild @view
        @onMount()
        @


    behind: (dom) ->
        if @parent
            throw new Error 'Please remove node from parent node before adding to the real dom.'
        parent = dom.parentNode
        next   = dom.nextSibling
        checkDom parent if ViewNode.CHECK_DOM
        if next
            parent.insertBefore @view, next
        else
            parent.appendChild @view
        @onMount()
        @


    before: (dom) ->
        if @parent
            throw new Error 'Please remove node from parent node before adding to the real dom.'
        parent = dom.parentNode
        checkDom parent if ViewNode.CHECK_DOM
        parent.insertBefore @view, dom
        @onMount()
        @


    replace: (dom) ->
        if @parent
            throw new Error 'Please remove node from parent node before adding to the real dom.'
        parent = dom.parentNode
        if ViewNode.CHECK_DOM
            checkDom parent
            checkDom dom
        parent.replaceChild @view, dom
        @onMount()
        @


    remove: () ->
        if @parent
            throw new Error 'Please remove node from parent node instead of removing from real dom.'
        parent = @view.parentNode
        checkDom parent if ViewNode.CHECK_DOM
        parent.removeChild @view
        @onUnmount()
        @



    #    000  000   000  000  000000000
    #    000  0000  000  000     000   
    #    000  000 0 000  000     000   
    #    000  000  0000  000     000   
    #    000  000   000  000     000

    init: (cfg) ->



    #    000   000  00000000   0000000     0000000   000000000  00000000
    #    000   000  000   000  000   000  000   000     000     000
    #    000   000  00000000   000   000  000000000     000     0000000
    #    000   000  000        000   000  000   000     000     000
    #     0000000   000        0000000    000   000     000     00000000

    update: () => update @
    render: () -> @cfg




    #     0000000   0000000   000      000      0000000     0000000    0000000  000   000   0000000
    #    000       000   000  000      000      000   000  000   000  000       000  000   000     
    #    000       000000000  000      000      0000000    000000000  000       0000000    0000000 
    #    000       000   000  000      000      000   000  000   000  000       000  000        000
    #     0000000  000   000  0000000  0000000  0000000    000   000   0000000  000   000  0000000 

    onMount:   () ->
    onUnmount: () -> @keep




    #    00000000    0000000   00000000   000   000  000       0000000   000000000  00000000
    #    000   000  000   000  000   000  000   000  000      000   000     000     000     
    #    00000000   000   000  00000000   000   000  000      000000000     000     0000000 
    #    000        000   000  000        000   000  000      000   000     000     000     
    #    000         0000000   000         0000000   0000000  000   000     000     00000000

    populate: () ->
        if @view
            throw new Error "View already exists"

        if _.isNot cfg = @render()
            throw new Error "A view for an empty cfg can't be created."

        if _.isSimple cfg
            @createTextView text: cfg

        else if _.isString tag = cfg.tag
            @createTagView cfg

        else if _.isDom cfg
            @createTagFromDom  null, cfg

        else if _.isDomText cfg
            @createTextFromDom  null, cfg

        else if _.isDom tag
            @createTagFromDom cfg, tag

        else if _.isDomText tag
            @createTextFromDom cfg, tag

        else if _.isSimpleOrNull(text = cfg.text) or _.isFunc text # TODO: inconsistent with updateProps -> CHECK!!!
            @createTextView cfg

        else
            if _.extendsNode tag
                throw new Error "A tag must be a string or a HTMLElement, you specified a ViewNode class."
            throw new Error "A tag must be a string or a HTMLElement."

        domList.push(@view) if ViewNode.CHECK_DOM
        @




    createTextView: (cfg) ->
        text = cfg.text
        text = text() if _.isFunc text
        if not _.isSimpleOrNull text
            throw new Error "The text for a text node must be either a string, number or bool or a function returning one of these types."
        @text = text + ''
        @tag  = cfg.tag  = undefined
        @kind = ViewNode.TEXT_KIND
        @view = document.createTextNode text
        @


    createTextFromDom: (cfg, dom) ->
        checkDom dom if ViewNode.CHECK_DOM
        @text = dom.nodeValue
        @tag  = undefined
        @kind = ViewNode.TEXT_KIND
        @view = dom
        if cfg
            text = cfg.text
            if _.isNot text
                cfg.text = @text
            else
                text = text() if _.isFunc text
                if not _.isSimple text
                    throw new Error "The text for a text node must be either a string, number or bool or a function returning one of these types."
                @text = dom.nodeValue = text + ''
        else
            @cfg = text: @text + ''
        @cfg.tag = undefined
        #console.log 'createTextFromDom', @text, @view.nodeValue
        @


    createTagView: (cfg) ->
        @tag  = cfg.tag
        @kind = ViewNode.TAG_KIND
        @view = document.createElement cfg.tag
        @updateProps cfg
        @


    createTagFromDom: (cfg, dom) ->
        checkDom dom if ViewNode.CHECK_DOM
        @tag    = dom.nodeName.toLowerCase()
        @kind   = ViewNode.TAG_KIND
        @view   = dom
        if not cfg
            @cfg = tag: @tag
            #TODO: create from dom children
        else
            #TODO: init from dom children
            @updateProps cfg
        @




    #    000   000  00000000   0000000     0000000   000000000  00000000        000   000   0000000   000   000
    #    000   000  000   000  000   000  000   000     000     000             0000  000  000   000  000 0 000
    #    000   000  00000000   000   000  000000000     000     0000000         000 0 000  000   000  000000000
    #    000   000  000        000   000  000   000     000     000             000  0000  000   000  000   000
    #     0000000   000        0000000    000   000     000     00000000        000   000   0000000   00     00

    updateNow: () ->
        cfg = @render()
        #TODO: remove, if necessary
        if @kind == ViewNode.TAG_KIND
            @updateProps cfg
        else
            @updateText cfg
        @




    #    000   000  00000000   0000000     0000000   000000000  00000000         0000000  00000000   0000000 
    #    000   000  000   000  000   000  000   000     000     000             000       000       000      
    #    000   000  00000000   000   000  000000000     000     0000000         000       000000    000  0000
    #    000   000  000        000   000  000   000     000     000             000       000       000   000
    #     0000000   000        0000000    000   000     000     00000000         0000000  000        0000000 

    updateCfg: (@cfg) ->
        if @cfg and @cfg.inject
            @inject = @cfg.inject
            @[key] = value for key, value of @inject
        true




    #    000000000  00000000  000   000  000000000
    #       000     000        000 000      000   
    #       000     0000000     00000       000   
    #       000     000        000 000      000   
    #       000     00000000  000   000     000   

    updateText: (cfg) ->
        text = if _.isSimpleOrNull(cfg) then cfg else cfg.text
        text = text() if _.isFunc text
        text += ''
        if @text != text
            @text = @view.nodeValue = text
        @




    #    00000000   00000000    0000000   00000000    0000000
    #    000   000  000   000  000   000  000   000  000     
    #    00000000   0000000    000   000  00000000   0000000 
    #    000        000   000  000   000  000             000
    #    000        000   000   0000000   000        0000000 

    updateProps: (cfg) ->
        if @updating
            console.error 'Already updating: ', @
        @updating      = true
        @attrs         = @attrs    or {}
        @events        = @events   or {}
        @children      = @children or []
        updateChildren = cfg.updateChildren != false
        if cfg.text != undefined
            @updateChildren [cfg.text] if updateChildren

            if ViewNode.DEBUG
                if cfg.child != undefined
                    console.warn 'child specified while text exists: ', cfg
                if cfg.children != undefined
                    console.warn 'children specified while text exists', cfg

        else if cfg.child != undefined
            @updateChildren [cfg.child] if updateChildren

            if ViewNode.DEBUG
                if cfg.children != undefined
                    console.warn 'children specified while child exists', cfg

        else if cfg.children != undefined
            if updateChildren
                if _.isFunc cfg.children
                    @updateChildren cfg.children()
                else
                    @updateChildren cfg.children

        else if @children.length and updateChildren
            @updateChildren []

        if cfg.className != undefined or @attrs.className != undefined
            @updateClassName cfg.className

        if cfg.style != undefined or @attrs.style != undefined
            @updateStyle cfg.style

        propMap      = {}
        propMap[key] = true for key of cfg
        propMap[key] = true for key of @attrs
        propMap[key] = true for key of @events

        ignore = ViewNode.IGNORES
        for name of propMap
            continue if ignore[name]

            attr  = @attrs[name]
            value = cfg[name]

            if _.isBool(value) or (_.isNot(value) and _.isBool(attr))
                @updateBool value, name
            else
                if name[0] == 'o' and name[1] == 'n'
                    @updateEvent value, name
                else
                    value = value() if _.isFunc value
                    if _.isBool value
                        @updateBool value, name
                    else
                        @updateAttr value, name
        @updating = false
        @




    #     0000000   000000000  000000000  00000000    0000000
    #    000   000     000        000     000   000  000     
    #    000000000     000        000     0000000    0000000 
    #    000   000     000        000     000   000       000
    #    000   000     000        000     000   000  0000000 

    updateAttr: (value, name) ->
        @attrs[name] = @view.getAttribute name
        return if @attrs[name] == value
        view = @view
        if value != null and value != undefined
            view.setAttribute name, value
            view[name]       = value
            @attrs[name] = value
        else
            view.removeAttribute name
            delete view[name]
            delete @attrs[name]
        @




    #    0000000     0000000    0000000   000    
    #    000   000  000   000  000   000  000    
    #    0000000    000   000  000   000  000    
    #    000   000  000   000  000   000  000    
    #    0000000     0000000    0000000   0000000

    updateBool: (value, name) ->
        @attrs[name] = @view[name]
        return if @attrs[name] == value
        view = @view
        if _.isNot value
            view.removeAttribute name
            view[name] = false
            delete @attrs[name]
        else if  value == false
            view.removeAttribute name
            view[name]       = false
            @attrs[name] = false
        else
            view.setAttribute name, ''
            view[name]       = true
            @attrs[name] = true
        @




    #     0000000  000       0000000    0000000   0000000        000   000   0000000   00     00  00000000
    #    000       000      000   000  000       000             0000  000  000   000  000   000  000     
    #    000       000      000000000  0000000   0000000         000 0 000  000000000  000000000  0000000 
    #    000       000      000   000       000       000        000  0000  000   000  000 0 000  000     
    #     0000000  0000000  000   000  0000000   0000000         000   000  000   000  000   000  00000000

    updateClassName: (value) ->
        value = value() if _.isFunc value

        @attrs.className = cn = @view.className
        return if cn == value

        if _.isNot value
            if cn != value
                @view.className  = undefined
                delete @attrs.className

        else if _.isString value
            if cn != value
                @view.className  = value
                @attrs.className = value

        else
            cl      = @view.classList
            ca      = []
            changed = false
            if _.isArray value
                for v in value
                    clazz    = v[0]
                    use      = v[1]
                    contains = cl.contains clazz
                    if use
                        ca.push clazz
                        changed = changed or not contains
                    else
                        changed = changed or contains
            else
                for clazz, use of value
                    contains = cl.contains clazz
                    if use
                        ca.push clazz
                        changed = true if not contains
                    else
                        changed = true if contains
            if changed
                @attrs.className = @view.className = ca.join ' '
        @




    #     0000000  000000000  000   000  000      00000000
    #    000          000      000 000   000      000     
    #    0000000      000       00000    000      0000000 
    #         000     000        000     000      000     
    #    0000000      000        000     0000000  00000000

    updateStyle: (value) ->
        view  = @view
        attrs = @attrs
        style = attrs.style

        value = value() if _.isFunc value

        if _.isNot value
            if style != value
                view.style.cssText = null
                delete attrs.style

        else if _.isString value
            if style != value
                view.style.cssText = value
                attrs.style        = value

        else
            css     = ''
            style   = if _.isObject(style) then style else {}
            changed = false
            propMap = {} #Object.assign {}, style, value
            propMap[key] = true for key of style
            propMap[key] = true for key of value
            for name of propMap
                v = value[name]
                changed = changed or v != style[name]
                style[name] = v
                if _.isNot v
                    delete style[name]
                else
                    prop  = _.normalizeName name
                    css  += prop + ': ' + v + '; '

            if changed
                if css.length
                    css                = css.slice 0, -1
                    view.style.cssText = css
                else
                    view.style.cssText = null
                    delete attrs.style
        @




    #    00000000  000   000  00000000  000   000  000000000   0000000
    #    000       000   000  000       0000  000     000     000     
    #    0000000    000 000   0000000   000 0 000     000     0000000 
    #    000          000     000       000  0000     000          000
    #    00000000      0      00000000  000   000     000     0000000 

    updateEvent: (callback, name) ->
        type     = _.normalizeEvent name
        listener = @events[name]

        if _.isString callback
            callback = (args...) => @[name].apply @, args

        if listener != callback
            if listener
                @view.removeEventListener(type, listener)
                delete @events[name]
            if callback
                @view.addEventListener(type, callback)
                @events[name] = callback
        @




    removeEvents: () ->
        events = @events
        return null if not events

        view = @view
        for name, listener of events
            type = _.normalizeEvent name
            view.removeEventListener(type, listener) if listener
        @events = {}
        @




    #     0000000  000   000  000  000      0000000    00000000   00000000  000   000
    #    000       000   000  000  000      000   000  000   000  000       0000  000
    #    000       000000000  000  000      000   000  0000000    0000000   000 0 000
    #    000       000   000  000  000      000   000  000   000  000       000  0000
    #     0000000  000   000  000  0000000  0000000    000   000  00000000  000   000

    updateChildren: (cfgs) ->
        children = @children.concat()
        cfgs     = [cfgs] if _.isSimple cfgs
        oldL     = children.length
        newL     = cfgs.length
        l        = if oldL > newL then oldL else newL
        for i in [0...l]
            child  = children[i]
            cfg    = cfgs[i]
            cfg    = cfg() if _.isFunc cfg
            hasCfg = cfg != undefined

            if not child and not hasCfg
                throw new Error "DOM ERROR: either child or cfg at index #{i} must be defined. Got " + child + ', ' + cfg

            if not child and hasCfg
                @addChild cfg

            else if child and not hasCfg
                @removeChild child

            else
                @changeChild child, cfg

        @children.length = newL if newL != oldL and newL != @children.length
        @




    #     0000000   0000000    0000000  
    #    000   000  000   000  000   000
    #    000000000  000   000  000   000
    #    000   000  000   000  000   000
    #    000   000  0000000    0000000  

    addChild: (childOrCfg) ->
        cfg = childOrCfg
        if _.isNodeInstance cfg
            child = cfg
            if child.parent
                keep = child.keep
                child.keep = true
                child.parent.removeChild child
                child.keep = keep
        else
            cfg.inject = @inject if not cfg.inject
            child = create cfg

        child.parent = @
        child.depth  = @depth + 1

        @children.push child
        @view.appendChild child.view

        child.onMount()
        child




    #    00000000   00000000  00     00   0000000   000   000  00000000
    #    000   000  000       000   000  000   000  000   000  000     
    #    0000000    0000000   000000000  000   000   000 000   0000000 
    #    000   000  000       000 0 000  000   000     000     000     
    #    000   000  00000000  000   000   0000000       0      00000000

    removeChild: (child) ->
        index = @children.indexOf child
        if index > -1
            @children.splice index, 1
        if @view.contains child.view
            @view.removeChild child.view
        dispose child
        child




    #     0000000  000   000   0000000   000   000   0000000   00000000
    #    000       000   000  000   000  0000  000  000        000     
    #    000       000000000  000000000  000 0 000  000  0000  0000000 
    #    000       000   000  000   000  000  0000  000   000  000     
    #     0000000  000   000  000   000  000   000   0000000   00000000

    changeChild: (child, cfg) ->
        if _.isNodeInstance cfg

            if child == cfg
                child.updateNow()
            else
                child = @replaceChild child, cfg

        else if _.isString child.tag

            if ((child.tag == cfg.tag and child.constructor == ViewNode) or child.constructor == cfg.tag)
                if child.updateCfg cfg
                    child.updateProps child.render()
            else
                child = @replaceChild child, cfg

        else if _.isSimple child.text
            text = if _.isSimpleOrNull(cfg) then cfg else cfg.text
            text = text() if _.isFunc text
            if (_.isSimpleOrNull text)
                if child.updateCfg cfg
                    child.updateText child.render()
            else
                child = @replaceChild child, cfg
        else
            child = @replaceChild child, cfg
        child




    #    00000000   00000000  00000000   000       0000000    0000000  00000000
    #    000   000  000       000   000  000      000   000  000       000     
    #    0000000    0000000   00000000   000      000000000  000       0000000 
    #    000   000  000       000        000      000   000  000       000     
    #    000   000  00000000  000        0000000  000   000   0000000  00000000

    replaceChild: (child, newChildOrCfg) ->
        cfg      = newChildOrCfg
        children = @children
        i        = children.indexOf child
        view     = child.view

        dispose child

        if _.isNodeInstance cfg
            child = cfg
            if child.parent
                keep = child.keep
                child.keep = true
                child.parent.removeChild child
                child.keep = keep
        else
            cfg.inject = @inject if not cfg.inject
            child = create cfg

        children[i]  = child
        child.parent = @
        child.depth  = @depth + 1
        @view.replaceChild child.view, view
        child.onMount()
        child








#     0000000  000   000  00000000   0000000  000   000        0000000     0000000   00     00
#    000       000   000  000       000       000  000         000   000  000   000  000   000
#    000       000000000  0000000   000       0000000          000   000  000   000  000000000
#    000       000   000  000       000       000  000         000   000  000   000  000 0 000
#     0000000  000   000  00000000   0000000  000   000        0000000     0000000   000   000

checkDom = (dom) ->
    if domList.indexOf(dom) > -1
        throw new Error 'Dom element already controlled by another node.'
    dom




#     0000000  00000000   00000000   0000000   000000000  00000000
#    000       000   000  000       000   000     000     000     
#    000       0000000    0000000   000000000     000     0000000 
#    000       000   000  000       000   000     000     000     
#     0000000  000   000  00000000  000   000     000     00000000

create = (cfg) ->
    if not _.extendsNode clazz = cfg.clazz or cfg.tag
        clazz = null
        if _.isDom(dom = cfg) or _.isDom(dom = cfg.tag)
            tag = dom.nodeName.toLowerCase()
        clazz = classMap[tag] if _.isString tag = tag or cfg.tag

    clazz = clazz or ViewNode.DEFAULT_CLASS
    new clazz cfg




#    0000000    000   0000000  00000000    0000000    0000000  00000000
#    000   000  000  000       000   000  000   000  000       000
#    000   000  000  0000000   00000000   000   000  0000000   0000000
#    000   000  000       000  000        000   000       000  000
#    0000000    000  0000000   000         0000000   0000000   00000000

dispose = (node) ->
    if node.onUnmount() != true
        node.removeEvents()

        if node.children and node.children.length
            dispose child for child in node.children

        delete node.children
        delete node.view
        delete nodeMap[node.__id__]

    node.parent = null
    node.depth  = undefined
    node




#    000   000  00000000   0000000     0000000   000000000  00000000
#    000   000  000   000  000   000  000   000     000     000     
#    000   000  00000000   000   000  000000000     000     0000000 
#    000   000  000        000   000  000   000     000     000     
#     0000000   000        0000000    000   000     000     00000000

update = (node) ->
    id = node?.__id__
    if not id
        throw new Error "Can't update node. ViewNode doesn't exist."

    if not dirty
        window.cancelAnimationFrame rafTimeout
        rafTimeout = window.requestAnimationFrame performUpdate

    dirtyMap[id] = true
    dirty        = true
    null




#    00000000   00000000  00000000   00000000   0000000   00000000   00     00  00000000
#    000   000  000       000   000  000       000   000  000   000  000   000  000     
#    00000000   0000000   0000000    000000    000   000  0000000    000000000  0000000 
#    000        000       000   000  000       000   000  000   000  000 0 000  000     
#    000        00000000  000   000  000        0000000   000   000  000   000  00000000

performUpdate = () ->
    window.cancelAnimationFrame rafTimeout
    dirty    = false
    nodes    = []
    (nodes.push(n) if n = nodeMap[id]) for id of dirtyMap
    nodes.sort (a, b) -> a.depth - b.depth
    for node in nodes
        continue if not node.view or not nodeMap[node.__id__] or not dirtyMap[node.__id__]
        node.updateNow()

    dirtyMap = {}
    null




#    00     00   0000000   00000000 
#    000   000  000   000  000   000
#    000000000  000000000  00000000 
#    000 0 000  000   000  000      
#    000   000  000   000  000      

map = (tag, clazz, overwrite = false) ->
    if _.isNot(classMap[tag]) or overwrite
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




callResize = (node) ->
    node.onResize() if node.onResize
    if node.children
        callResize child for child in node.children
    node




handleResize = () ->
    for key, node of nodeMap
        callResize node if not node.parent and node.view
    null




ViewNode.create       = create
ViewNode.dispose      = dispose
ViewNode.map          = map
ViewNode.unmap        = unmap
ViewNode.callResize   = callResize
ViewNode.handleResize = handleResize
ViewNode.default      = ViewNode



#    00000000  000   000  00000000    0000000   00000000   000000000
#    000        000 000   000   000  000   000  000   000     000   
#    0000000     00000    00000000   000   000  0000000       000   
#    000        000 000   000        000   000  000   000     000   
#    00000000  000   000  000         0000000   000   000     000

module.exports = ViewNode