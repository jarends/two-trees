ViewTree = require('../two-trees').ViewTree
CompNode = require('../two-trees').CompNode


class InputView extends CompNode


    render: ->
        tag: 'p'
        children: [
            tag:      'input'
            type:     'checkbox'
            style:    ()  => "display: #{if @tree.root.numTotal > 0 then 'inline-block' else 'none'};"
            checked:  ()  => @tree.root.numDone == @tree.root.numTotal and @tree.root.numTotal > 0
            onChange: (e) => @cfg.allDone e.target.checked
            bindings: [
                [@tree.root, 'numDone']
                [@tree.root, 'numTotal']
            ]
        ,
            tag:         'input'
            type:        'text'
            placeholder: 'What needs to be done?'
            onKeyup:     (e) =>
                if e.keyCode == 13 and v = e.target.value
                    e.target.value = ''
                    @cfg.addTask v
        ]


class TaskView extends CompNode


    render: ->
        tag: 'li'
        children: [
            tag:      'input'
            type:     'checkbox'
            checked:  ()  => @cfg.task.done
            onChange: (e) => @cfg.taskDone e.target.checked, @cfg.index
            bindings: [
                [@cfg.task, 'done']
            ]
        ,
            tag:    'input'
            type:   'text'
            value:    ()  => @cfg.task.text
            onChange: (e) =>
                @cfg.task.text = e.target.value
                @tree.update()
            bindings: [
                [@cfg.task, 'text']
            ]
        ]


class AppView extends ViewTree.Node


    constructor: (cfg) ->
        super cfg
        @data = @tree.root

        
    addTask: (text) =>
        @data.numTotal = @data.tasks.push text: text or 'task', done: false
        @tree.update()


    allDone: (select) =>
        t.done = select for t in @data.tasks
        @data.numDone = if select then @data.tasks.length else 0
        @tree.update()


    taskDone: (select, index) =>
        @data.tasks[index].done = select
        if select then ++@data.numDone else --@data.numDone
        @tree.update()


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
                tag:      'ol'
                bindings: [
                    [@data.tasks, '*']
                ]
                children: () =>
                    for t, i in @data.tasks
                        tag:   TaskView
                        task:  t
                        index: i
                        taskDone: @taskDone
            ]
        ,
            tag: 'p'
            children: [
                text: () => (@data.numTotal - @data.numDone) + ' items left'
                bindings: [
                    [@data, 'numDone']
                    [@data, 'numTotal']
                ]
            ]
        ]




module.exports = AppView