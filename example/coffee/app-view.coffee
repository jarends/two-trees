ViewTree = require '../../src/js/view-tree'


class AppView extends ViewTree.Node


    constructor: (cfg) ->
        super(cfg)
        @model = cfg.model
        @data  = cfg.model.root
        @title = @data.title
        @data.title = @title + " click me!"


    onClick: () =>
        @data.bgGreen = Math.random() * 100 + 155
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
            title:     'page title'
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
            onClick:   @undo
            children: 'undo'
            style:    "display: #{@model.historyIndex < 1 and 'none' or ''};"
        ,
            tag:      'button'
            onClick:   @redo
            children: 'redo'
            style:    "display: #{(@model.historyIndex >= @model.history.length) and 'none' or ''};"
        ]




module.exports = AppView