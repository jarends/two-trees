CompNode = require('../two-trees').CompNode


class InputView extends CompNode

    render: ->
        tag: 'p'
        children: [
            tag:         'input'
            type:        'text'
            placeholder: 'What needs to be done?'
            onKeyup:     (e) =>
                if e.keyCode == 13 and v = e.target.value
                    e.target.value = ''
                    @cfg.addTask v
        ,
            tag:      'input'
            type:     'checkbox'
            style:    ()  => "display: #{if @tree.root.numTotal > 0 then 'inline-block' else 'none'};"
            checked:  ()  => @tree.root.numDone == @tree.root.numTotal and @tree.root.numTotal > 0
            onChange: (e) => @cfg.allDone e.target.checked
            bindings: [
                [@tree.root, 'numDone']
                [@tree.root, 'numTotal']
            ]
        ]


class TaskView extends CompNode

    render: ->
        tag: 'li'
        children: [
            tag:      'input'
            type:     'checkbox'
            checked:  ()  =>
                #console.log 'update task checked: ', @cfg.task.text, @cfg.task.done
                @cfg.task.done
            onChange: (e) => @cfg.taskDone e.target.checked or false, @cfg.index
            bindings: [
                [@cfg.task, 'done']
            ]
        ,
            tag:        'input'
            type:       'text'
            tabIndex:   0
            readonly:   !@editable
            value:      ()  => @cfg.task.text
            onDblclick: ()  =>
                @editable = true
                @update()
            onChange: (e) =>
                @cfg.task.text = e.target.value
                @editable = false
                @tree.update @cfg.task
                @update()
            onBlur: () =>
                if @editable
                    @editable = false
                    @update()
            bindings: [
                [@cfg.task, 'text']
            ]
        ,
            tag: 'button'
            children: 'x'
            onClick: () => @cfg.removeTask @cfg.index
        ]


class FilterButton extends CompNode

    constructor: (cfg) ->
        super cfg
        @bind @cfg.data, 'filter'

    render: () ->
        tag:       'button'
        className: () => if @cfg.data.filter == @cfg.name then 'active' else null
        children:  @cfg.name
        onClick:   () => @cfg.setFilter @cfg.name


class AppView extends CompNode


    updateCfg: (cfg) ->
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


    setFilter: (name) =>
        @data.filter = name
        @tree.update()


    removeTask: (index) =>
        --@data.numTotal
        --@data.numDone if @data.tasks[index].done
        @data.tasks.splice index, 1
        @tree.update()


    clearCompleted: () =>
        tasks = @data.tasks.slice()
        index = 0
        for t in tasks
            if t.done then @data.tasks.splice(index, 1) else ++index
        @data.numTotal = index
        @data.numDone  = 0
        @tree.update()


    render: ->
        tag:      'div'
        style:    'padding: 20px;'
        children: [
            tag: 'h1',     children: 'todo ' + (@data.tasks.length or '')
        ,
            tag: 'button', children: 'undo', onClick: () => @tree.undo()
        ,
            tag: 'button', children: 'redo', onClick: () => @tree.redo()
        ,
            tag: InputView, addTask: @addTask, allDone: @allDone
        ,
            tag:      'ol'
            bindings: [
                [@data,       'filter']
                [@data,       'numDone']
                [@data,       'numTotal']
                [@data.tasks, '*']
            ]
            children: () =>
                f = @data.filter
                for t, i in @data.tasks when f == 'all' or (t.done and f == 'done') or (not t.done and f == 'undone')
                    tag:        TaskView
                    task:       t
                    index:      i
                    taskDone:   @taskDone
                    removeTask: @removeTask
        ,
            tag:      'p'
            child:
                text: () => (@data.numTotal - @data.numDone) + ' items left'
                bindings: [
                    [@data, 'numDone']
                    [@data, 'numTotal']
                ]
        ,
            tag:      'p'
            children: [
                'show: '
            ,
                tag: FilterButton, data: @data, setFilter: @setFilter, name: 'all'
            ,
                tag: FilterButton, data: @data, setFilter: @setFilter, name: 'done'
            ,
                tag: FilterButton, data: @data, setFilter: @setFilter, name: 'undone'
            ]
        ,
            tag:      'button'
            style:    () => "display: #{if @tree.root.numDone > 0 then 'inline-block' else 'none'};"
            text:     'clear completed'
            onClick:  () => @clearCompleted()
            bindings: [
                [@data, 'numDone']
            ]
        ]


module.exports = AppView