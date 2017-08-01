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

    constructor: (opts) ->
        #console.log 'constructor A: '
        @updateCfg opts
        @create()

    updateCfg: (cfg) ->
        @cfg = cfg
        true

    create: () ->
        console.log 'create: ', @render()

    render: () ->
        ';-)'


class B extends A

    constructor: (opts) ->
        #console.log 'constructor B: '
        super opts

    updateCfg: (cfg) ->
        @data = cfg.data
        super cfg

    render: () ->
        @data + ' ' + super()


class C extends B

    constructor: (opts) ->
        #console.log 'constructor C: '
        super opts

    updateCfg: (cfg) ->
        @bla = cfg.bla
        super cfg

    render: () ->
        @bla + ' and ' + super()


a = new A()
b = new B({data:'hello from B'})
c = new C({data:'hello from B, child of C', bla:'hello from C'})
















