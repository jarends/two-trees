TreeOne = require '../../src/js/tree-one'
TreeTwo = require '../../src/js/tree-two'
AppView = require './app-view'


class Context


    constructor: () ->
        console.log(';-)');

        model = new TreeTwo
            title:   'Hello two-trees'
            bgGreen: 255

        app = new AppView model: model
        TreeOne.render app, document.querySelector '.app'

        ###
        Treedom.map 'app', AppView
        Treedom.create tag: 'app'
        Treedom.create 'Hello Text Node'
        Treedom.create
            tag: 'h1'
            children: 'Hello H1 Node'


        test = require 'es6-promise!./test'
        test().then (result) ->
            console.log 'test exports: ', result
        ###


module.exports = new Context()