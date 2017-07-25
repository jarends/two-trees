trees    = require '../two-trees'
AppView  = require './app-view'
ViewTree = trees.ViewTree
DataTree = trees.DataTree
CompNode = trees.CompNode

# set CompNode as default class for each node to enable bindings
ViewTree.DEFAULT_CLASS = CompNode


model = new DataTree
    title:   'hello two-trees!'
    bgGreen: 255
    clicks:  0


app = ViewTree.create
    tag: AppView
    __i__:
        tree: model


ViewTree.render app, document.querySelector '.app'


# expose model for testing bindings in console
window.model = model
window.data  = model.root


# in console type:
#
# data.clicks = 1
# model.update()
