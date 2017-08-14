trees    = require '../two-trees'
AppView  = require './app-view'
DataTree = trees.DataTree
ViewNode = trees.ViewNodeSmall
CompNode = trees.CompNode


ViewNode.DEFAULT_CLASS = CompNode


model = new DataTree
    tasks:    []
    numDone:  0
    numTotal: 0
    filter:   'all'


app = new AppView
    __i__:
        tree: model


app.appendTo document.querySelector '.app'
