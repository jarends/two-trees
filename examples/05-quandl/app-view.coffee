CompNode = require('../two-trees').CompNode
GraphView = require './graph-view'

class InputView extends CompNode

    render: ->
        tag: 'p'
        children: [
            tag:         'input'
            type:        'text'
            placeholder: 'SYMBOL?'
            onKeyup:     (e) =>
                if e.keyCode == 13 and sym = e.target.value
                    e.target.value = ''
                    @cfg.addGraph sym
        ]

class AppView extends CompNode
        
    updateCfg: (cfg) ->
        @data = @tree.root
                
    addGraph: (sym) =>
        @data.graphs.push symbol: sym
        @tree.update()

    render: ->
        tag:      'div'
        style:    'padding: 20px;'
        children: [
            tag:      'div'
            bindings: [
                [@data.graphs, '*']
            ]
            children: () =>
                for graph, index in @data.graphs
                    tag:   GraphView
                    graph: graph
                    index: index
        ,
            tag: InputView, addGraph: @addGraph
        ]

module.exports = AppView

