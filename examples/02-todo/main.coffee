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
    tag:   AppView
    __i__:
        tree: model

        
app.appendTo document.querySelector '.app'


window.model = model
window.data  = model.root
