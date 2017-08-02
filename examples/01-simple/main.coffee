trees    = require '../two-trees'
AppView  = require './app-view'
ViewNode = trees.ViewNode
DataTree = trees.DataTree

model = new DataTree
    title:   'hello two-trees!'
    bgGreen: 255

app = ViewNode.create
    tag:   AppView
    model: model

app.appendTo document.querySelector '.app'
