trees    = require '../two-trees'
AppView  = require './app-view'
ViewTree = trees.ViewTree
DataTree = trees.DataTree

model = new DataTree
    title: 'todo'
    tasks: []

app = ViewTree.create
    tag:   AppView
    __i__:
        tree: model

ViewTree.render app, document.querySelector '.app'
