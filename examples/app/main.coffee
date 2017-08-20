trees    = require '../two-trees'
AppView  = require './app-view'
DataTree = trees.DataTree
ViewNode = trees.ViewNode
CompNode = trees.CompNode


ViewNode.DEFAULT_CLASS = CompNode


model = new DataTree
    tasks:    []
    numDone:  0
    numTotal: 0
    filter:   'all'


app = new AppView
    inject:
        tree: model


app.appendTo document.querySelector '.example-app'
