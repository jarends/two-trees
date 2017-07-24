trees    = require '../app/two-trees'
AppView  = require './app-view'
ViewTree = trees.ViewTree
DataTree = trees.DataTree

model = new DataTree
    title:   'hello two-trees!'
    bgGreen: 255

app = ViewTree.create
    tag:   AppView
    model: model

ViewTree.render app, document.querySelector '.app'
