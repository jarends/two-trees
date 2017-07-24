trees    = require '../two-trees'
AppView  = require './app-view'
ViewTree = trees.ViewTree
DataTree = trees.DataTree
CompNode = trees.CompNode


ViewTree.DEFAULT_CLASS = CompNode

model = new DataTree
    title:   'hello two-trees!'
    bgGreen: 255

app = ViewTree.create
    tag:   AppView
    model: model
    __i__:
        tree: model

ViewTree.render app, document.querySelector '.app'
