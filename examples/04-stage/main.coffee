trees    = require '../two-trees'
AppView  = require './app-view'
ViewTree = trees.ViewTree
DataTree = trees.DataTree
CompNode = trees.CompNode
Node     = trees.Node


ViewTree.DEFAULT_CLASS = CompNode


model = new DataTree
    tasks:    []
    numDone:  0
    numTotal: 0
    filter:   'all'

###
app = new AppView
    tag: document.querySelector '.app'
    inject:
        model: model
###


new Node
    tag:'div'

Node.create
    tag:'div'


#console.log new Node tag: document.querySelector '.app'

#console.log new Node 'my cfg text'

#console.log new Node text: 'my cfg.text text'





window.model = model
window.data  = model.root
