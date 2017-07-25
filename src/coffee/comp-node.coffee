ViewTree = require './view-tree'


class CompNode extends ViewTree.Node


    constructor: (cfg) ->
        super(cfg)


    register: (cfg) ->
        super(cfg)

        @paths = []
        throw new Error "Tree not injected." if not @tree

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


    bind: (obj, name, callback) ->
        @paths.push @tree.bind(obj, name, callback or @update)


    unbind: (paths) ->
        index = @paths.indexOf paths
        if index == -1
            console.error 'Paths not bound by this comp. paths = ', paths
            throw new Error 'Paths not bound by this comp.'
        @paths.splice index, 1
        @tree.unbind paths


    unbindAll: () ->
        allUnbound  = true
        (allUnbound = allUnbound && @tree.unbind paths) for paths in @paths
        @paths      = []
        allUnbound




module.exports = CompNode