ViewTree = require('../two-trees').ViewTree
CompNode = require('../two-trees').CompNode


class InputView extends CompNode

    render: ->
        tag: 'p'
        children: [
            tag:      'input'
            type:     'checkbox'
            onChange: (e) => @cfg.allDone e.target.checked
        ,
            tag:    'input'
            type:   'text'
            onKeyup: (e) =>
                if e.keyCode == 13 and v = e.target.value
                    e.target.value = ''
                    @cfg.addTask v
        ]


class TaskView extends CompNode

    render: ->
        tag: 'li'
        children: [
            tag:    'input'
            type:   'text'
            value:  () => @cfg.task.text
            onChange: (e) =>
                @cfg.task.text = e.target.value
                @tree.update()
            bindings: [
                [@cfg.task, 'text']
            ]
        ,
            tag:      'input'
            type:     'checkbox'
            checked:  ()  => @cfg.task.done
            onChange: (e) =>
                @cfg.task.done = e.target.checked
                @tree.update()
            bindings: [
                [@cfg.task, 'done']
            ]
        ]


class AppView extends ViewTree.Node


    constructor: (cfg) ->
        super cfg
        @data = @tree.root

        
    addTask: (text) =>
        @data.numTotal = @data.tasks.push text: text or 'task', done: false
        console.log '@data.numTotal: ', @data.numTotal
        @tree.update()


    allDone: (select) =>
        t.done = select for t in @data.tasks
        @data.numDone = @data.tasks.length
        @tree.update()


    taskDone: (select, index) =>
        t = @data.tasks[index]
        t.done = select
        if selected then ++@data.numDone else --@data.numDone


        
    render: ->
        tag: 'div'
        children: [
            tag:      'h1'
            children: [ @data.title + " " + (@data.tasks.length or '') ]
        ,
            tag:      'button'
            onClick:   () => @tree.undo() ;
            children: 'undo'
        ,
            tag:      'button'
            onClick:  () => @tree.redo() ;
            children: 'redo'
        ,
            tag:     InputView
            addTask: @addTask
            allDone: @allDone
        ,
            tag:      'form'
            children: [
                tag: 'fieldset'
                bindings: [
                    [@data.tasks, '*']
                ]
                children: [
                    tag:      'ol'
                    children: () => 
                        for t, i in @data.tasks
                            tag:   TaskView
                            task:  t
                            index: i
                            taskDone: @taskDone
                ]
            ]
        ,
            tag: 'p'
            children: [
                text: () =>
                    console.log 'update!!!'
                    'left todos: ' + (@data.numTotal - @data.numDone)
                bindings: [
                    [@data, 'numDone']
                    [@data, 'numTotal']
                ]
            ]
        ]




module.exports = AppView