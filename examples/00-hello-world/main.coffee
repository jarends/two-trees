ViewNode = require('../two-trees').ViewNode

app = ViewNode.create 'Hello World ;-)'

app.appendTo document.querySelector '.app'

