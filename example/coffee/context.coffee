ViewTree = require '../../src/js/view-tree'
DataTree = require '../../src/js/data-tree'
AppView  = require './app-view'


class Context


    constructor: () ->

        model = new DataTree
            title:   'hello two-trees!'
            bgGreen: 255

        app = new AppView model: model
        ViewTree.render app, document.querySelector '.app'

        
module.exports = new Context()