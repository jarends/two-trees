trees     = require '../two-trees'
DataTree  = trees.DataTree
CompNode  = trees.CompNode
Dashboard = require './dashboard'


#ViewNode.DEFAULT_CLASS = CompNode


###
model = new DataTree
    tasks:    []
    numDone:  0
    numTotal: 0
    filter:   'all'


app = new AppView
    __i__:
        tree: model


app.appendTo document.querySelector '.app'
###


class App


    setData: (@data) ->
        #console.log 'setData'
        @model = new DataTree @data
        @dashboard = new Dashboard data: @data
        @dashboard.appendTo document.getElementById 'dashboard'


    update: (@data) ->
        #console.log 'update'
        @model.update(@data)
        @dashboard.update()


    undo: () ->
        #console.log 'undo'
        @model.undo()
        @dashboard.update()


    redo: () ->
        #console.log 'redo'
        @model.redo()
        @dashboard.update()


window.app = new App()