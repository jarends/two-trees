ViewTree = require('../app/two-trees').ViewTree

app = ViewTree.create 'Hello World ;-)'

ViewTree.render app, document.querySelector '.app'
