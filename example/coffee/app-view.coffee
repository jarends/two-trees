TreeOne = require '../../src/js/tree-one'


class AppView extends TreeOne.Node


    constructor: (cfg) ->
        super(cfg)
        @model = cfg.model
        @data  = cfg.model.root
        @title = @data.title


    onClick: () =>
        @data.bgGreen = (Math.random() * 200 + 55) >> 0
        @data.title   = @title + '!!!!!'.slice((Math.random() * 5) >> 0)
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
                tag:      'span'
                children: @data.title
            ]
        ,
            tag:      'button'
            onClick:   @undo
            children: 'undo'
        ,
            tag:      'button'
            onClick:   @redo
            children: 'redo'
        ]




module.exports = AppView