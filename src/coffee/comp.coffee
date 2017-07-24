ViewTree = require './view-tree'


class Comp extends ViewTree.Node


    @TREE_NAME = 'tree'


    constructor: (cfg) ->
        super(cfg)




    getTree: () ->
        tree = @[Comp.TREE_NAME]
        if not tree
            throw new Error "Tree not set on property '#{Comp.TREE_NAME}'."
        tree




    bind: (obj, name, callback) ->
        @paths.push getTree().bind(obj, name, callback)




    unbind: (paths) ->
        index = @paths.indexOf paths
        if index == -1
            console.error 'Paths not bound by this comp. paths = ', paths
            throw new Error 'Paths not bound by this comp.'
        @paths.splice index, 1
        getTree().unbind paths




    unbindAll: () ->
        tree = getTree()
        allUnbound = true
        (allUnbound = allUnbound && tree.unbind paths) for paths in @paths
        @paths = []
        allUnbound




    register: (cfg) ->
        super(cfg)




    onUnmount: () ->
        @unbindAll()
        super()




module.exports = Comp