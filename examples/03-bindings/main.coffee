trees    = require '../two-trees'
AppView  = require './app-view'
ViewTree = trees.ViewTree
DataTree = trees.DataTree
CompNode = trees.CompNode


ViewTree.DEFAULT_CLASS = CompNode


model = new DataTree
    title:   'hello two-trees! click me!'
    bgGreen: 255
    clicks:  0


app = ViewTree.create
    tag:   AppView
    model: model
    __i__:
        tree: model


ViewTree.render app, document.querySelector '.app'


window.model = model
window.data  = model.root
