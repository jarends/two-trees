ViewTree = require '../../src/js/view-tree'


class AppView extends ViewTree.Node


    constructor: (cfg) ->
        super cfg
        @model      = cfg.model
        @data       = cfg.model.root
        @title      = @data.title
        @data.title = @title + " click me!"


    onClick: () =>
        @data.bgGreen = (Math.random() * 100 + 155) >> 0
        @data.title   = @title + " clicks: #{@model.historyIndex + 1}"
        @model.update()
        @update()
        null


    undo: () =>
        @model.undo()
        @update()


    redo: () =>
        @model.redo()
        @update()


    render: () ->
        tag: 'div'
        children: [
            tag:       'h1'
            className: 'my-class'
            style:     "background-color: rgb(0,#{@data.bgGreen},0);"
            onClick:   @onClick
            children:  [
                tag:      'div'
                style:    'padding: 20px;'
                children: @data.title
            ]
        ,
            tag:      'button'
            disabled:  @model.historyIndex < 1
            onClick:   @undo
            children: 'undo'
        ,
            tag:      'button'
            disabled: @model.historyIndex >= @model.history.length
            onClick:  @redo
            children: 'redo'
        ]




module.exports = AppView