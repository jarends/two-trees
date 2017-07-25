ViewTree = require('../two-trees').ViewTree


class AppView extends ViewTree.Node


    constructor: (cfg) ->
        super cfg
        @model      = cfg.model
        @data       = cfg.model.root

    addTask: () =>
        @data.tasks.push tag: 'li', children: [
            tag:    'input'
            value:  'task'
        , 
            tag:    'input'
            type:   'checkbox'
            value:  false
        ]
        @model.update()
        @update()

    render: () ->

        tag: 'div'
        children: [
            tag:      'h1'
            onClick:  @addTask
            children: [ @data.title + " " + (@data.tasks.length or '') ]
        ,
            tag:      'button'
            disabled:  @model.historyIndex < 1
            onClick:   () => @model.undo() ; @update()
            children: 'undo'
        ,
            tag:      'button'
            disabled: @model.historyIndex >= @model.history.length
            onClick:  () => @model.redo() ; @update()
            children: 'redo'
        , 
            tag: 'form'
            children: [
                tag: 'fieldset'
                children: [
                    tag:      'ol'
                    children: @data.tasks
                ]
            ]
        ]




module.exports = AppView