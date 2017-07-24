ViewTree = require './view-tree'


class CompNode extends ViewTree.Node


    @TREE_NAME = 'tree'


    constructor: (cfg) ->
        super(cfg)




    getTree: () ->
        tree = @[CompNode.TREE_NAME]
        if not tree
            throw new Error "Tree not set on property '#{Comp.TREE_NAME}'."
        tree




    bind: (obj, name, callback) ->
        @paths.push @getTree().bind(obj, name, callback or @update)




    unbind: (paths) ->
        index = @paths.indexOf paths
        if index == -1
            console.error 'Paths not bound by this comp. paths = ', paths
            throw new Error 'Paths not bound by this comp.'
        @paths.splice index, 1
        @getTree().unbind paths




    unbindAll: () ->
        tree = @getTree()
        allUnbound = true
        (allUnbound = allUnbound && tree.unbind paths) for paths in @paths
        @paths = []
        allUnbound




    register: (cfg) ->
        super(cfg)
        @paths = []
        if bindings = cfg.bindings
            for binding in bindings
                if Array.isArray binding
                    @bind binding[0], binding[1]
                else
                    @bind binding
        @__id__



    onUnmount: () ->
        @unbindAll()
        super()




module.exports = CompNode