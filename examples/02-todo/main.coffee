trees    = require '../two-trees'
AppView  = require './app-view'
ViewTree = trees.ViewTree
DataTree = trees.DataTree

model = new DataTree
    title: 'todo'
    tasks: []

app = ViewTree.create
    tag:   AppView
    model: model

ViewTree.render app, document.querySelector '.app'
