ViewTree = require '../../src/js/view-tree'


class AppView extends ViewTree.Node


    constructor: (cfg) ->
        super(cfg)
        @model = cfg.model
        @data  = cfg.model.root
        @title = @data.title


        @bgGreen1 = @model.bind @data,      'bgGreen',  (value, obj, name, path) => console.log 'bgGreen1 changed: ', value
        @bgGreen2 = @model.bind @data,      'bgGreen',  (value, obj, name, path) => console.log 'bgGreen2 changed: ', value
        @model.bind @data.test, 'bla',      (value, obj, name, path) => console.log 'test.bla changed: ',     value
        @model.bind @data.a[0], null,       (value, obj, name, path) -> console.log 'a[0] changed: ',         value
        @model.bind @data.a[0], 'hello',    (value, obj, name, path) -> console.log 'a.0.hello changed: ',    value
        @model.bind @data.a[0], 'helloNew', (value, obj, name, path) -> console.log 'a.0.helloNew changed: ', value
        @model.bind @data.a[0], '*',        (value, obj, name, path) -> console.log 'a.0.* changed: ',        value
        @clicks = 0

        @greater = ViewTree.create
            tag: 'h5'
            children: 'greater 128'
            onClick: @onGreaterClicked

        @greater.keep = true
        #console.log 'APP VIEW: ', @ctx


    onGreaterClicked: () =>
        console.log 'greater clicked'

    onClick: () =>
        @data.bgGreen    = (Math.random() * 200 + 55) >> 0
        @data.title      = @title + '!!!!!'.slice((Math.random() * 5) >> 0)
        @data.a[0].hello = 'world!'
        @data.a[0]       = @newA = @newA or {helloNew: 'worldNew'}
        @data.test.bla   = 'blup'

        @model.update()
        @update()

        if ++@clicks == 5
            console.log 'unbind bgGreen'
            @model.unbind @bgGreen1
        null


    undo: () =>
        @model.undo()
        #console.log '@data.a.0 undo: ', @data.a['0']
        @update()


    redo: () =>
        @model.redo()
        #console.log '@data.a.0 redo: ', @data.a['0']
        @update()


    render: () ->
        children = [
            tag:       'h1'
            title:     'page title'
            className: 'my-class'
            style:     "background-color: rgb(0,#{@data.bgGreen},0);"
            onClick:   @onClick
            children:  [
                tag:      'span'
                children: [
                    text: @data.title
                ]
                __i__: ctx: @
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

        if @data.bgGreen > 128
            children.push @greater

        tag:      'div'
        children: children





module.exports = AppView