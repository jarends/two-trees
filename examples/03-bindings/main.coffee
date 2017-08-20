trees    = require '../two-trees'
AppView  = require './app-view'
DataTree = trees.DataTree
ViewNode = trees.ViewNode
CompNode = trees.CompNode

# set CompNode as default class for each node to enable bindings
ViewNode.DEFAULT_CLASS = CompNode


model = new DataTree
    title:   'hello two-trees!'
    bgGreen: 255
    clicks:  0


app = ViewNode.create
    tag: AppView
    inject:
        tree: model


app.appendTo document.querySelector '.app'


# expose model for testing bindings in console
window.model = model
window.data  = model.root


# in console type:
#
# data.clicks = 1
# model.update()
