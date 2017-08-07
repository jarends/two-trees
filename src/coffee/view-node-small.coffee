_          = require './utils'
__id__     = 0
nodeMap    = {}
dirtyMap   = {}
classMap   = {}
dirty      = false
rafTimeout = null



class ViewNode


    constructor: (cfg) ->
        @parent = null
        @depths = 0
        @__id__ = ++__id__
        nodeMap[@__id__] = @
        @updateCfg cfg
        @populate()




    appendTo: (dom) ->
        dom.appendChild @view
        @




    updateCfg: (@cfg) -> true
    update: () -> update @
    render: () -> @cfg




    populate: () ->
        cfg = @render()
        if _.isSimple cfg
            @text = cfg + ''
            @view = document.createTextNode cfg

        else if _.isString tag = cfg.tag
            @tag  = tag
            @view = document.createElement tag
            @updateProps cfg

        else if _.isSimple text = cfg.text
            @text = text + ''
            @view = document.createTextNode text

        else if _.isFunc text
            @text = text() + ''
            @view = document.createTextNode @text
        @




    updateNow: () ->
        cfg = @render()
        if _.isString @tag
            @updateProps cfg
        else
            @updateText cfg
        @




    updateText: (cfg) ->
        if not _.isString text = cfg
            if not _.isString text = cfg.text
                text = text() if _.isFunc text
        text += ''
        if @text != text
            @text = @view.nodeValue = text
        @




    updateProps: (cfg) ->
        @attrs    = @attrs    or {}
        @events   = @events   or {}
        @children = @children or []

        if cfg.text != undefined
            @updateChildren [cfg.text]

        else if cfg.child != undefined
            @updateChildren [cfg.child]

        else if cfg.children != undefined
            if _.isFunc cfg.children
                @updateChildren cfg.children()
            else
                @updateChildren cfg.children

        else if @children.length
            @updateChildren []

        if cfg.className != undefined or @attrs.className != undefined
            @updateClassName cfg.className

        if cfg.style != undefined or @attrs.style != undefined
            @updateStyle cfg.style

        @




    updateClassName: (value) ->
        value = value() if _.isFunc value

        #@attrs.className = @view.className
        return if @attrs.className == value
        if value
            @view.className  = value
            @attrs.className = value
        else
            @view.className  = undefined
            delete @attrs.className
        @




    updateStyle: (value) ->
        view  = @view
        attrs = @attrs
        style = attrs.style

        value = value() if _.isFunc value

        if _.isNot value
            if attrs.style != value
                view.style.cssText = null
                delete attrs.style

        else if _.isString value
            if attrs.style != value
                view.style.cssText = value
                attrs.style        = value

        else
            css     = ''
            style   = if _.isObject(style) then style else {}
            changed = false
            propMap = Object.assign {}, style, value
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




    updateEvent: (callback, name) ->
        type      = _.normalizeEvent name
        listener  = @events[name]

        if _.isString callback
            callback = @[name]

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
            delete events[name]
        @




    updateChildren: (cfgs) ->
        children = @children
        oldL     = children.length
        newL     = cfgs.length
        l        = if oldL > newL then oldL else newL
        for i in [0...l]
            child  = children[i]
            cfg    = cfgs[i]
            cfg    = cfg() if _.isFunc cfg
            hasCfg = cfg != undefined and cfg != null

            if not child and hasCfg
                @addChild cfg

            else if child and not hasCfg
                @removeChild child

            else
                @changeChild child, cfg
        @




    addChild: (cfg) ->
        if _.isNodeInstance cfg
            child = cfg
            if child.parent
                keep = child.keep
                child.keep = true
                child.parent.removeChild child
                child.keep = keep
        else
            child = create cfg

        child.parent = @
        child.depths = @depths + 1

        @children.push child
        @view.appendChild child.view
        @




    removeChild: (child) ->




    changeChild: (child, cfg) ->
        if _.isNodeInstance cfg

            if child == cfg
                child.updateNow()
            else
                @replaceChild child, cfg

        else if _.isString child.tag

            if (child.tag == cfg.tag or child.constructor == cfg.tag)
                if child.updateCfg cfg
                    child.updateProps child.render()
            else
                @replaceChild child, cfg

        else if _.isSimple child.text

            if (_.isSimple(cfg) or _.isSimple(cfg.text))
                if child.updateCfg cfg
                    child.updateText child.render()
            else
                @replaceChild child, cfg
        else
            @replaceChild child, cfg
        @




    replaceChild: (child, cfg) ->
        throw new Error 'REPLACE!!!'
        children = @children
        i        = children.indexOf child
        view     = child.view

        @disposeNode child

        if _.isNodeInstance cfg
            child = cfg
            if child.parent
                keep = child.keep
                child.keep = true
                child.parent.removeChild child
                child.keep = keep
        else
            child = create cfg

        children[i]  = child
        child.parent = @
        child.depth  = @depth + 1
        @view.replaceChild child.view, view
        @








create = (cfg) ->
    if not _.extendsNode clazz = cfg.clazz or cfg.tag
        clazz = ViewNode
    clazz = clazz or ViewNode
    new clazz cfg




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




ViewNode.create = create
ViewNode.map    = map
ViewNode.unmap  = unmap




module.exports = ViewNode