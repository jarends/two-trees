__id__ = 0


class TreeTwo


    constructor: (root) ->
        @nodeMap      = {}
        @bindings     = {}
        @history      = []
        @historyIndex = 0
        @setRoot(root) if root




    setRoot: (obj) ->
        #TODO: add disposement for existing root
        @rootNode = @createNode null, '/', obj
        @root     = obj


    getRoot: () ->
        return null if not @rootNode
        @rootNode.value


    has: (obj) ->
       typeof obj == 'object' and @nodeMap[obj.__node_id__] != undefined




    bind: (obj, name, callback) ->
        node  = if typeof obj == 'object' then @nodeMap[obj.__node_id__] else null
        paths = @addPaths node, name, null, (path) =>
            callbacks = @bindings[path] or @bindings[path] = []
            if callbacks.indexOf(callback) == -1
                console.log 'add binding: ', path
                callbacks.push callback
        #console.log 'bind to: ', paths
        paths




    unbind: (obj, name, callback) ->
        node = if typeof obj == 'object' then @nodeMap[obj.__node_id__] else null
        @addPaths node, name, null, (path) =>
            callbacks = @bindings[path]
            if callbacks
                index = callbacks.indexOf callback
                if index > -1
                    callbacks.splice index, 1




    update: (obj, name) ->
        node = if typeof obj == 'object' then @nodeMap[obj.__node_id__] else @rootNode
        if node
            @currentActions = []
            @currentPaths   = {}
            @updatedMap     = {}
            if name != undefined
                @updateProp node, name
            else
                @updateNode node

            if @currentActions.length
                if @historyIndex < @history.length
                    #TODO: !!! add disposement
                    @history.length = @historyIndex
                @history.push @currentActions
                ++@historyIndex
                #console.log 'changed paths: ', @currentPaths
                @currentActions.paths = @currentPaths
                @dispatchBindings @currentPaths
        else
            console.error error = 'Error: object not part of this tree: ', obj
            throw new Error error
        false




    undo: () ->
        if @historyIndex > 0
            actions = @history[--@historyIndex]
            action.undo() for action in actions
            #console.log 'undo: ', actions
            @dispatchBindings actions.paths
        else
            console.log 'undo not possible!!! ', @historyIndex
        null




    redo: () ->
        if @historyIndex < @history.length   
            actions = @history[@historyIndex++]
            action.redo() for action in actions
            #console.log 'redo: ', actions
            @dispatchBindings actions.paths
        else
            console.log 'redo not possible!!! ', @historyIndex
        null




    dispatchBindings: (paths) ->
        called     = []
        dispatched = false
        for path, node of paths
            callbacks = @bindings[path]
            name      = path.split('/').pop() or ''
            value     = node.value
            #console.log 'dispatch path: ', path, node.value[name]
            if callbacks
                for callback in callbacks
                    if called.indexOf(callback) == -1
                        callback value[name], value, name, path
                        dispatched = true
                        called.push callback
        dispatched




    createNode: (owner, name, value) ->
        node = @nodeMap[value.__node_id__] if value
        if not node
            id = ++__id__
            node =
                id:     id
                value:  value
                type:   'value'
                owners: {}

            @nodeMap[node.id] = node
            if owner
                #console.log 'add path: ', name, owner
                @addPaths owner, name, @currentPaths
                addOwner(node, owner, name)

            if value
                if value.constructor.name == 'Array'
                    Object.defineProperty value, '__node_id__',
                        value:      node.id
                        enumerable: false

                    node.type  = 'array'
                    node.props = props = []
                    l          = value.length
                    for i in [0 ... l]
                        props[i] = @createNode node, i, value[i]

                else if value.constructor.name == 'Object'
                    Object.defineProperty value, '__node_id__',
                        value:      node.id
                        enumerable: false

                    node.type  = 'object'
                    node.props = props = {}
                    for key of value
                        props[key] = @createNode node, key, value[key]
        node




    updateNode: (node) ->
        return true if @updatedMap[node.id]
        @updatedMap[node.id] = true

        value = node.value
        props = node.props
        if node.type == 'array'
            pl = props.length
            vl = value.length
            l  = if pl > vl then pl else vl
            for i in [0...l]
                @updateProp node, i
            if pl != vl
                @addChangeLengthAction node, pl, vl
                props.length = vl

        else if node.type == 'object'
            keys = Object.assign {}, props, value
            for key of keys
                @updateProp node, key
        null




    updateProp: (node, name) ->
        child = node.props[name]
        value = node.value[name]

        if not child and value == undefined
            console.error "Error: either old or new value must exist for property \"#{name}\" of node: ", node
            return false

        # value != undefined but no child, so create a new child
        if not child
            child = @createNode node, name, value
            @addCreateAction child, node, name

        # child exists but no value, so remove the child
        else if value == undefined
            @updateNode child if child.type != 'value'
            removeOwner child, node, name
            @addRemoveAction child, node, name

        else
            # not changed
            if child.value == value

                # the child's value hasn't changed, so update the child
                if child.type != 'value'
                    @updateNode(child) if not @updatedMap[child.id]

                # no change of simple node
                else
                    return false
            # changed
            else
                type = 'value'
                if value
                    if value.constructor.name == 'Array'
                        type = 'array'
                    else if value.constructor.name == 'Object'
                        type = 'object'

                # value changed from simple to complex or reverse or instance changed, so replace the child
                if type != 'value' or type != child.type
                    @updateNode child if child.type != 'value'
                    removeOwner child, node, name
                    next = @createNode node, name, value
                    @addSwapAction child, node, name, next

                # skip unnecessary creation of simple nodes, because they are unique to their owner
                else
                    @addChangeValueAction child, node, name, value
                    child.value = value
        null




    addCreateAction: (node, owner, name) ->
        @addPaths owner, name, @currentPaths
        @currentActions.push
            type:  'create'
            undo: () -> removeOwner node, owner, name
            redo: () -> addOwner    node, owner, name
        null


    addRemoveAction: (node, owner, name) ->
        @addPaths owner, name, @currentPaths
        @currentActions.push
            type:  'remove'
            undo: () -> addOwner    node, owner, name
            redo: () -> removeOwner node, owner, name
        null


    addSwapAction: (node, owner, name, next) ->
        @addPaths owner, name, @currentPaths
        @currentActions.push
            type:  'swap'
            undo: () ->
                removeOwner next, owner, name
                addOwner    node, owner, name
            redo: () ->
                removeOwner node, owner, name
                addOwner    next, owner, name
        null


    addChangeValueAction: (node, owner, name, newValue) ->
        @addPaths owner, name, @currentPaths
        @currentActions.push
            type:  'changeValue'
            oldValue: node.value
            undo: () ->
                node.value        = this.oldValue
                owner.value[name] = this.oldValue
            redo: () ->
                node.value        = newValue
                owner.value[name] = newValue
        null


    addChangeLengthAction: (node, oldLength, newLength) ->
        @currentActions.push
            type:  'changeLength'
            undo: () -> node.value.length = node.props.length = oldLength
            redo: () -> node.value.length = node.props.length = newLength
        null




    addPaths: (node, path, paths, callback, root) ->
        path  = if path == null or path == undefined then '' else path + ''
        path  = '/' + path if path
        paths = paths or {}
        root  = root or node
        #console.log 'addPaths: ', path
        if node == @rootNode
            #console.log 'add path: ', path
            paths[path] = root or node
            callback path if callback
        else
            for id, names of node.owners
                owner = @nodeMap[id]
                for n of names
                    @addPaths owner, n + path, paths, callback, root
        paths




addOwner = (node, owner, name) ->
    owners = node.owners
    names  = owners[owner.id] || owners[owner.id] = {}
    if names[name]
        return null
    names[name]       = true
    owner.props[name] = node
    owner.value[name] = node.value
    null




removeOwner = (node, owner, name) ->
    owners = node.owners
    names  = owners[owner.id]
    if not names or not names[name]
        return null
    delete names[name]
    delete owner.props[name]
    delete owner.value[name]
    null



#    0000000    00000000  00000000  000  000   000  00000000        00000000   00000000    0000000   00000000
#    000   000  000       000       000  0000  000  000             000   000  000   000  000   000  000   000
#    000   000  0000000   000000    000  000 0 000  0000000         00000000   0000000    000   000  00000000
#    000   000  000       000       000  000  0000  000             000        000   000  000   000  000
#    0000000    00000000  000       000  000   000  00000000        000        000   000   0000000   000


if Object.defineProperty == undefined
    Object.defineProperty = (obj, name, data) ->
        obj[name] = data.value




if typeof module != 'undefined'
    module.exports = TreeTwo
if typeof window != 'undefined'
    window.TreeTwo = TreeTwo
else
    this.TreeTwo = TreeTwo