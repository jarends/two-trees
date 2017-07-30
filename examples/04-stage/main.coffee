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

app = new Node
    tag:'div'
    title: 'my title'
    disabled: false
    children: [
        tag: 'div'
        title: 'div child'
    ]


app.appendTo document.querySelector '.app'

console.log app

#app.cfg.title = 'my title!!!'
#app.update()


#console.log new Node tag: document.querySelector '.app'

#console.log new Node 'my cfg text'

#console.log new Node text: 'my cfg.text text'


window.model = model
window.data  = model.root
