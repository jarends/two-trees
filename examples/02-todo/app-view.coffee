ViewTree = require('../two-trees').ViewTree
CompNode = require('../two-trees').CompNode

class TaskView extends CompNode
    
    constructor: (cfg) ->
        @task  = cfg.task
        delete cfg.task
        super cfg
        
    render: ->
        
        tag: 'li'
        children: [
                tag:    'input'
                value:  @task.text
                onChange: (e) => 
                    @task.text = e.target.value
                    console.log @task
                    @tree.update()
            , 
                tag:    'input'
                type:   'checkbox'
                value:  @task.done
            ]

class AppView extends ViewTree.Node


    constructor: (cfg) ->
        super cfg
        @data = @tree.root

        
    addTask: =>
        @data.tasks.push text: 'task', done: false
        @tree.update()
        @update()

        
    render: ->

        tag: 'div'
        children: [
            tag:      'h1'
            onClick:  @addTask
            children: [ @data.title + " " + (@data.tasks.length or '') ]
        ,
            tag:      'button'
            disabled:  @tree.historyIndex < 1
            onClick:   () => @tree.undo() ; @update()
            children: 'undo'
        ,
            tag:      'button'
            disabled: @tree.historyIndex >= @tree.history.length
            onClick:  () => @tree.redo() ; @update()
            children: 'redo'
        , 
            tag: 'form'
            children: [
                tag: 'fieldset'
                children: [
                    tag:      'ol'
                    children: () => 
                        for t in @data.tasks
                            tag:   TaskView 
                            task:  t
                ]
            ]
        ]




module.exports = AppView