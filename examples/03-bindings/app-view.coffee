ViewTree = require('../two-trees').ViewTree


class AppView extends ViewTree.Node


    constructor: (cfg) ->
        super cfg
        @model = cfg.model
        @data  = cfg.model.root
        @title = @data.title


    onClick: () =>
        ++@data.clicks
        @data.bgGreen = (Math.random() * 100 + 155) >> 0
        @data.title   = @title.replace(' click me!', '') + " clicks: #{@data.clicks}"
        @model.update()


    render: () ->
        cfg =
            tag: 'div'
            children: [
                tag:       'h1'
                className: 'my-class'
                onClick: @onClick
                children:  [
                    tag:      'div'
                    style:    () => "padding: 20px; background-color: rgb(0,#{@data.bgGreen},0);"
                    bindings: [
                        [@data, 'bgGreen']
                        [@data, 'title']
                    ]
                    children: () => @data.title
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
                disabled: () => @data.clicks == @model.history.length
                onClick:  () => @model.redo()
                bindings: [
                    [@data, 'clicks']
                ]
                children: 'redo'
            ]
        cfg




module.exports = AppView