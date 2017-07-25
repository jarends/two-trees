ViewTree = require('../two-trees').ViewTree


class AppView extends ViewTree.Node


    constructor: (cfg) ->
        super cfg
        @model = @tree
        @data  = cfg.model.root


    render: () ->
        tag: 'div'
        children: [
            tag:       'h1'
            className: 'my-class'
            onClick: () =>
                ++@data.clicks
                @data.bgGreen = (Math.random() * 100 + 155) >> 0
                @model.update()
            children:  [
                tag:      'div'
                style:    () => "padding: 20px; background-color: rgb(0,#{@data.bgGreen},0);"
                bindings: [
                    [@data, 'bgGreen']
                    [@data, 'clicks']
                ]
                children: () =>
                    if @data.clicks
                        @data.title + " clicks: #{@data.clicks}"
                    else
                        @data.title + ' click me!'
            ]
        ,
            tag:      'button'
            disabled:  () => @data.clicks == 0
            onClick:   () => @model.undo()
            bindings: [
                [@data, 'clicks']
            ]
            children: 'undo'
        ,
            tag:      'button'
            disabled: () => @data.clicks >= @model.history.length
            onClick:  () => @model.redo()
            bindings: [
                [@data, 'clicks']
            ]
            children: 'redo'
        ]




module.exports = AppView