trees    = require '../two-trees'
AppView  = require './app-view'
ViewTree = trees.ViewTree
DataTree = trees.DataTree
CompNode = trees.CompNode


ViewTree.DEFAULT_CLASS = CompNode


model = new DataTree
    tasks:    []
    numDone:  0
    numTotal: 0
    filter:   'all'

###
app = ViewTree.create
    tag:   AppView
    __i__:
        tree: model


ViewTree.render app, document.querySelector '.app'
###

app = new AppView
    __i__:
        tree: model


app.appendTo document.querySelector '.app'


window.model = model
window.data  = model.root













class A

    constructor: (cfg) ->
        console.log 'constructor A: '
        @populate A


    populate: (clazz) ->
        if @constructor == clazz
            console.log 'populate: ', @


class B extends A

    constructor: (cfg) ->
        super cfg
        console.log 'constructor B: '
        @data = cfg.data
        @populate B


class C extends B

    constructor: (cfg) ->
        super cfg
        console.log 'constructor C: '
        @bla = cfg.bla
        @populate C


new C({})












class A

    constructor: (cfg) ->
        console.log 'constructor A: '
        @populate()


    populate: (clazz) ->
        console.log 'populate: ', @


class B extends A

    constructor: (cfg) ->
        console.log 'constructor B: '
        @data = cfg.data
        super cfg


class C extends B

    constructor: (cfg) ->
        console.log 'constructor C: '
        @bla = cfg.bla
        super cfg


new C({})


















