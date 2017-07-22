ViewTree = require '../../src/js/view-tree'


class AppView extends ViewTree.Node


    constructor: (cfg) ->
        super(cfg)
        @model = cfg.model
        @data  = cfg.model.root
        @title = @data.title

        @model.bind @data.test, 'bla',      () -> console.log 'test.bla changed: '
        @model.bind @data,      'bgGreen',  () -> console.log 'bgGreen changed: '
        @model.bind @data.a[0], null,       () -> console.log 'a[0] changed: '
        @model.bind @data.a,    '0',        () -> console.log 'a.0 changed: '
        @model.bind @data.a[0], 'hello',    () -> console.log 'a.0.hello changed: '
        @model.bind @data.a[0], 'helloNew', () -> console.log 'a.0.helloNew changed: '


    onClick: () =>
        @data.bgGreen    = (Math.random() * 200 + 55) >> 0
        @data.title      = @title + '!!!!!'.slice((Math.random() * 5) >> 0)
        @data.a[0].hello = 'world!'
        @data.a[0]       = @newA = @newA or {helloNew: 'worldNew'}
        @data.test.bla   = 'blup'

        @model.update()
        @update()
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