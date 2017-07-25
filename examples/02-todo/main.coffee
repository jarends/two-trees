trees    = require '../two-trees'
AppView  = require './app-view'
ViewTree = trees.ViewTree
DataTree = trees.DataTree
CompNode = trees.CompNode

ViewTree.DEFAULT_CLASS = CompNode

model = new DataTree
    title: 'todo'
    tasks: []
    numDone:  0
    numTotal: 0

app = ViewTree.create
    tag:   AppView
    __i__:
        tree: model

ViewTree.render app, document.querySelector '.app'


window.model = model
window.data  = model.root
