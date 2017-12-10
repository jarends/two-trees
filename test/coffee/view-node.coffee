Node  = require '../../src/js/view-node'
utils = require '../../src/js/utils'


#    000   000  000000000  000  000       0000000
#    000   000     000     000  000      000     
#    000   000     000     000  000      0000000 
#    000   000     000     000  000           000
#     0000000      000     000  0000000  0000000 

getTag  = (tag)  -> document.createElement  tag
getText = (text) -> document.createTextNode text

class MyValidNode extends Node
    render: () -> tag: 'div'

class MyMappedNode extends Node
    render: () -> tag: 'main'

class MyTextNode1 extends Node
    render: () -> 'text'

class MyTextNode2 extends Node
    render: () -> text: 'text'

class MyExtendedNode extends Node

class MyNodeWithEmptyCfg extends Node
    constructor: () -> super()
    render: () -> tag: 'div'

class MyCallbackNode extends Node
    call: (name) ->
        @called = @called or {}
        @called[name] = true

    onMount:          () -> @call 'onMount'
    onUnmount:        () -> @call 'onUnmount'
    onAddedToDom:     () -> @call 'onAddedToDom'
    onRemovedFromDom: () -> @call 'onRemovedFromDom'

    render: () -> tag: 'div'



Node.map 'main', MyMappedNode


expectClass   = (node, clazz) -> expect(node.constructor).to.equal clazz
expectExtends = (node, clazz) -> expect(node).to.be.instanceof clazz


expectTextNode = (node, clazz, text) ->
    expectClass   node, clazz
    expectExtends node.view, Text
    expect(node.kind).to.equal Node.TEXT_KIND
    expect(node.view.nodeValue).to.equal text + ''
    expect(node.text).to.equal text + ''

expectTagNode = (node, clazz, tag) ->
    expectClass   node, clazz
    expectExtends node.view, HTMLElement
    expect(node.kind).to.equal Node.TAG_KIND
    expect(node.view.nodeName.toLowerCase()).to.equal tag
    expect(node.tag).to.equal tag

expectAttr = (node, name, value) ->
    expectExtends node.view, HTMLElement
    expect(node.kind).to.equal Node.TAG_KIND
    expect(node.attrs[name]).to.equal value = utils.getOrCall value
    expect(node.view.getAttribute(name)).to.equal value + ''


expectBoolAttr = (node, name, value) ->
    expectExtends node.view, HTMLElement
    expect(node.attrs[name]).to.equal value = utils.getOrCall value
    if value == true
        expect(node.view.getAttribute(name)).to.equal ''
        expect(node.view[name]).to.equal value
    else
        expect(node.view.getAttribute(name)).to.equal null
        expect(node.view[name]).to.equal value








#     0000000  00000000   00000000   0000000   000000000  00000000
#    000       000   000  000       000   000     000     000
#    000       0000000    0000000   000000000     000     0000000
#    000       000   000  000       000   000     000     000
#     0000000  000   000  00000000  000   000     000     00000000

describe 'Node', () ->

    describe '.create', () ->

        it "should return a valid text node, if cfg = 'text'", () ->
            expectTextNode Node.create('text'), Node, 'text'

        it "should return a valid text node, if cfg = Text", () ->
            expectTextNode Node.create(getText('text')), Node, 'text'

        it "should return a valid text node, if cfg.text = 'text'", () ->
            expectTextNode Node.create(text: 'text'), Node, 'text'

        it "should return a valid text node, if cfg.text = null", () ->
            expectTextNode Node.create(text: null), Node, null

        it "should return a valid text node, if cfg.text = false", () ->
            expectTextNode Node.create(text: false), Node, false

        it "should return a valid text node, if cfg.text = 0", () ->
            expectTextNode Node.create(text: 0), Node, 0

        it "should return a valid text node, if cfg.tag = Text", () ->
            expectTextNode Node.create(tag: getText('text')), Node, 'text'

        it "should return a valid text node, if cfg.clazz = MyTextNode1", () ->
            expectTextNode Node.create(clazz: MyTextNode1), MyTextNode1, 'text'

        it "should return a valid text node, if cfg.clazz = MyTextNode2", () ->
            expectTextNode Node.create(clazz: MyTextNode2), MyTextNode2, 'text'

        it "should return a valid tag node, if cfg = HTMLELement", () ->
            expectTagNode Node.create(getTag('div')), Node, 'div'

        it "should return a valid tag node, if cfg.tag = 'div'", () ->
            expectTagNode Node.create(tag:'div'), Node, 'div'

        it "should return a valid tag node, if cfg.tag = HTMLELement", () ->
            expectTagNode Node.create(tag: getTag('div')), Node, 'div'

        it "should return a valid tag node with mapped class, if cfg = HTMLELement", () ->
            expectTagNode Node.create(getTag('main')), MyMappedNode, 'main'

        it "should return a valid tag node with mapped class, if cfg.tag = HTMLELement", () ->
            expectTagNode Node.create(tag: getTag('main')), MyMappedNode, 'main'

        it "should return a valid tag node, if cfg.tag = MyValidNode", () ->
            expectTagNode Node.create(tag: MyValidNode), MyValidNode, 'div'

        it "should return a valid tag node, if cfg.clazz = MyValidNode", () ->
            expectTagNode Node.create(clazz: MyValidNode), MyValidNode, 'div'

        it "should throw an error, if cfg = null", () ->
            expect(() -> Node.create()).to.throw()

        it "should throw an error, if neither tag nor text are set", () ->
            expect(() -> Node.create()).to.throw()

        it "should throw an error, if cfg.tag = MyExtendedNode", () ->
            expect(() -> Node.create(tag: MyExtendedNode)).to.throw()

        it "should throw an error, if cfg.tag is invalid", () ->
            expect(() -> Node.create(tag: 1))    .to.throw()
            expect(() -> Node.create(tag: true)) .to.throw()
            expect(() -> Node.create(tag: {}))   .to.throw()
            expect(() -> Node.create(tag: []))   .to.throw()
            expect(() -> Node.create(tag: () ->)).to.throw()

        it "should throw an error, if cfg.text is invalid", () ->
            expect(() -> Node.create(text: undefined)).to.throw()
            expect(() -> Node.create(text: {}))      .to.throw()
            expect(() -> Node.create(text: []))      .to.throw()
            expect(() -> Node.create(text: () ->))   .to.throw()
            expect(() -> Node.create(text: () -> {})).to.throw()
            expect(() -> Node.create(text: () -> [])).to.throw()

        it "should throw an error, if cfg.clazz = MyExtendedNode, because neither tag nor text are set", () ->
            expect(() -> Node.create(clazz: MyExtendedNode)).to.throw()

        it "should not throw an error, if cfg.clazz = MyExtendedNode and tag = 'div'", () ->
            Node.create({tag: 'div', clazz: MyExtendedNode})
            expect(() -> Node.create({tag: 'div', clazz: MyExtendedNode})).to.not.throw()

        it "should not throw an error, if cfg.clazz = MyExtendedNode and text = ''", () ->
            expect(() -> Node.create({text: '', clazz: MyExtendedNode})).to.not.throw()

        it "should not throw an error, if cfg.text is valid", () ->
            expect(() -> expectTextNode Node.create(text: ''),         Node, '')  .to.not.throw()
            expect(() -> expectTextNode Node.create(text: 1),          Node, 1)   .to.not.throw()
            expect(() -> expectTextNode Node.create(text: true),       Node, true).to.not.throw()
            expect(() -> expectTextNode Node.create(text: () -> ''),   Node, '')  .to.not.throw()
            expect(() -> expectTextNode Node.create(text: () -> 1),    Node, 1)   .to.not.throw()
            expect(() -> expectTextNode Node.create(text: () -> true), Node, true).to.not.throw()




#    000   000  00000000  000   000        000   000   0000000   0000000    00000000
#    0000  000  000       000 0 000        0000  000  000   000  000   000  000
#    000 0 000  0000000   000000000        000 0 000  000   000  000   000  0000000
#    000  0000  000       000   000        000  0000  000   000  000   000  000
#    000   000  00000000  00     00        000   000   0000000   0000000    00000000

describe 'new Node', () ->

    describe 'init', () ->

        it "should return a valid extended node, if no cfg is specified", () ->
            expectTagNode new MyNodeWithEmptyCfg(), MyNodeWithEmptyCfg, 'div'

        it "should return a valid text node, if cfg = 'text'", () ->
            expectTextNode new Node('text'), Node, 'text'

        it "should return a valid text node, if cfg = Text", () ->
            expectTextNode new Node(getText('text')), Node, 'text'

        it "should return a valid text node, if cfg.text = 'text'", () ->
            expectTextNode new Node(text: 'text'), Node, 'text'
            expectTextNode new Node(getText('text')), Node, 'text'

        it "should return a valid text node, if cfg.text = null", () ->
            expectTextNode new Node(text: null), Node, null

        it "should return a valid text node, if cfg.text = false", () ->
            expectTextNode new Node(text: false), Node, false

        it "should return a valid text node, if cfg.text = 0", () ->
            expectTextNode new Node(text: 0), Node, 0

        it "should return a valid text node, if cfg.tag = Text", () ->
            expectTextNode new Node(tag: getText('text')), Node, 'text'

        it "should return a valid tag node, if cfg = HTMLELement", () ->
            expectTagNode new Node(getTag('div')), Node, 'div'

        it "should return a valid tag node, if cfg.tag = 'div'", () ->
            expectTagNode new Node(tag:'div'), Node, 'div'

        it "should return a valid tag node, if cfg.tag = HTMLELement", () ->
            expectTagNode new Node(tag: getTag('div')), Node, 'div'

    describe 'init error', () ->
        it "should throw an error, if cfg = null", () ->
            expect(() -> new Node()).to.throw()

        it "should throw an error, if neither tag nor text are set", () ->
            expect(() -> new Node {}).to.throw()

        it "should throw an error, if cfg.tag is invalid", () ->
            expect(() -> new Node tag: 1).to.throw()
            expect(() -> new Node tag: true).to.throw()
            expect(() -> new Node tag: {}).to.throw()
            expect(() -> new Node tag: []).to.throw()
            expect(() -> new Node tag: () ->).to.throw()
            expect(() -> new Node tag: Node).to.throw()

        it "should throw an error, if cfg.text is invalid", () ->
            expect(() -> new Node text: undefined ).to.throw()
            expect(() -> new Node text: {}).to.throw()
            expect(() -> new Node text: []).to.throw()
            expect(() -> new Node text: () ->).to.throw()
            expect(() -> new Node text: () -> {}).to.throw()
            expect(() -> new Node text: () -> []).to.throw()

        it "should not throw an error, if cfg.text is valid", () ->
            expect(() -> expectTextNode new Node(text: ''),         Node, '')   .to.not.throw()
            expect(() -> expectTextNode new Node(text: 1),          Node, 1)   .to.not.throw()
            expect(() -> expectTextNode new Node(text: true),       Node, true).to.not.throw()
            expect(() -> expectTextNode new Node(text: () -> ''),   Node, '')  .to.not.throw()
            expect(() -> expectTextNode new Node(text: () -> 1),    Node, 1)   .to.not.throw()
            expect(() -> expectTextNode new Node(text: () -> true), Node, true).to.not.throw()

    describe 'with attr', () ->

        it "should create a attr title = 'my title'", () ->
            cfg = tag: 'div', title: 'my title'
            expectTagNode node = new Node(cfg), Node, 'div'
            expectAttr node, 'title', 'my title'

    describe 'with bool', () ->

        it "should create a bool attr disabled = true", () ->
            cfg = tag: 'div', disabled: true
            expectTagNode node = new Node(cfg), Node, 'div'
            expectBoolAttr node, 'disabled', true

        it "should create a bool attr disabled = false", () ->
            cfg = tag: 'div', disabled: false
            expectTagNode node = new Node(cfg), Node, 'div'
            expectBoolAttr node, 'disabled', false

        it "should remove a bool attr disabled = undefined", () ->
            cfg = tag: 'div', disabled: undefined
            expectTagNode node = new Node(cfg), Node, 'div'
            expectBoolAttr node, 'disabled', undefined

    describe 'with tag children', () ->

        it "should add a child tag node if children = [tag: 'div']", () ->
            cfg = tag: 'div', children: [tag: 'div']
            expectTagNode node = new Node(cfg), Node, 'div'
            expectTagNode node.children[0], Node, 'div'

        it "should add a child tag node with class MyExtendedNode if children = [{tag: 'div', clazz:MyExtendedNode}]", () ->
            cfg = tag: 'div', children: [{tag: 'div', clazz:MyExtendedNode}]
            expectTagNode node = new Node(cfg), Node, 'div'
            expectTagNode node.children[0], MyExtendedNode, 'div'

        it "should add a child tag node if children = [HTMLElement]", () ->
            cfg = tag: 'div', children: [getTag 'div']
            expectTagNode node = new Node(cfg), Node, 'div'
            expectTagNode node.children[0], Node, 'div'

        it "should add a child tag node if children = [tag:HTMLElement]", () ->
            cfg = tag: 'div', children: [tag:getTag 'div']
            expectTagNode node = new Node(cfg), Node, 'div'
            expectTagNode node.children[0], Node, 'div'

        it "should add a child tag node with class MyExtendedNode if children = [{tag: HTMLElement, clazz:MyExtendedNode}]", () ->
            cfg = tag: 'div', children: [{tag: getTag('div'), clazz:MyExtendedNode}]
            expectTagNode node = new Node(cfg), Node, 'div'
            expectTagNode node.children[0], MyExtendedNode, 'div'

    describe 'with tag child', () ->
        it "should add a child tag node if child = tag: 'div'", () ->
            cfg = tag: 'div', child: tag: 'div'
            expectTagNode node = new Node(cfg), Node, 'div'
            expectTagNode node.children[0], Node, 'div'

        it "should add a child tag node if child = HTMLElement", () ->
            cfg = tag: 'div', child: getTag 'div'
            expectTagNode node = new Node(cfg), Node, 'div'
            expectTagNode node.children[0], Node, 'div'

        it "should add a child tag node if child = tag: HTMLElement", () ->
            cfg = tag: 'div', child: tag: getTag 'div'
            expectTagNode node = new Node(cfg), Node, 'div'
            expectTagNode node.children[0], Node, 'div'

     describe 'with text children', () ->

        it "should add a child text node if children = 'my text'", () ->
            cfg = tag: 'div', children: 'my text'
            expectTagNode node = new Node(cfg), Node, 'div'
            expectTextNode node.children[0], Node, 'my text'

        it "should add a child text node if children = ['my text']", () ->
            cfg = tag: 'div', children: ['my text']
            expectTagNode node = new Node(cfg), Node, 'div'
            expectTextNode node.children[0], Node, 'my text'

        it "should add a child text node if children = [Text]", () ->
            cfg = tag: 'div', children: [getText 'my text']
            expectTagNode node = new Node(cfg), Node, 'div'
            expectTextNode node.children[0], Node, 'my text'

        it "should add a child text node if children = [text:'my text']", () ->
            cfg = tag: 'div', children: [text:'my text']
            expectTagNode node = new Node(cfg), Node, 'div'
            expectTextNode node.children[0], Node, 'my text'

        it "should add a child text node with class MyExtendedNode if children = [{text:'my text', clazz:MyExtendedNode}]", () ->
            cfg = tag: 'div', children: [text:'my text', clazz:MyExtendedNode]
            expectTagNode node = new Node(cfg), Node, 'div'
            expectTextNode node.children[0], MyExtendedNode, 'my text'

        it "should add a child text node with class MyExtendedNode if children = [{tag:Text, clazz:MyExtendedNode}]", () ->
            cfg = tag: 'div', children: [tag:getText('my text'), clazz:MyExtendedNode]
            expectTagNode node = new Node(cfg), Node, 'div'
            expectTextNode node.children[0], MyExtendedNode, 'my text'

    describe 'with text', () ->

        it "should add a child text node if text = 'my text'", () ->
            cfg = tag: 'div', text: 'my text'
            expectTagNode node = new Node(cfg), Node, 'div'
            expectTextNode node.children[0], Node, 'my text'

        it "should add a child text node if text = Text", () ->
            cfg = tag: 'div', text: getText 'my text'
            expectTagNode node = new Node(cfg), Node, 'div'
            expectTextNode node.children[0], Node, 'my text'

    describe 'with text child', () ->

        it "should add a child text node if child = 'my text'", () ->
            cfg = tag: 'div', child: 'my text'
            expectTagNode node = new Node(cfg), Node, 'div'
            expectTextNode node.children[0], Node, 'my text'

        it "should add a child text node if child = text:'my text'", () ->
            cfg = tag: 'div', child: text: 'my text'
            expectTagNode node = new Node(cfg), Node, 'div'
            expectTextNode node.children[0], Node, 'my text'

        it "should add a child text node if child = Text", () ->
            cfg = tag: 'div', child: getText 'my text'
            expectTagNode node = new Node(cfg), Node, 'div'
            expectTextNode node.children[0], Node, 'my text'

        it "should add a child text node if child = tag: Text", () ->
            cfg = tag: 'div', child: tag: getText 'my text'
            expectTagNode node = new Node(cfg), Node, 'div'
            expectTextNode node.children[0], Node, 'my text'




#    000  000   000   0000000  000000000   0000000   000   000   0000000  00000000
#    000  0000  000  000          000     000   000  0000  000  000       000
#    000  000 0 000  0000000      000     000000000  000 0 000  000       0000000
#    000  000  0000       000     000     000   000  000  0000  000       000
#    000  000   000  0000000      000     000   000  000   000   0000000  00000000

describe 'node instance', () ->


    #     0000000   00000000   00000000   00000000  000   000  000000000        000000000   0000000 
    #    000   000  000   000  000   000  000       0000  000     000              000     000   000
    #    000000000  00000000   00000000   0000000   000 0 000     000              000     000   000
    #    000   000  000        000        000       000  0000     000              000     000   000
    #    000   000  000        000        00000000  000   000     000              000      0000000 

    describe 'appendTo', () ->

        it 'should append the nodes view to the dom', () ->
            parent = getTag 'div'
            node   = new Node tag:'div'
            node.appendTo parent
            expect(parent.childNodes[0]).to.equal node.view
            expect(parent.childNodes.length).to.equal 1

        it 'should throw an error if the dom is controlled by a node', () ->
            checkDom = Node.CHECK_DOM
            Node.CHECK_DOM = true
            parent = new Node tag:'div'
            node   = new Node tag:'div'
            expect(() -> node.appendTo parent.view).to.throw()
            Node.CHECK_DOM = checkDom

        it 'should not throw an error if Node.CHECK_DOM = false', () ->
            checkDom = Node.CHECK_DOM
            Node.CHECK_DOM = false
            parent = new Node tag:'div'
            node   = new Node tag:'div'
            expect(() -> node.appendTo parent.view).to.not.throw()
            Node.CHECK_DOM = true
            Node.CHECK_DOM = checkDom


    #    0000000    00000000  000   000  000  000   000  0000000  
    #    000   000  000       000   000  000  0000  000  000   000
    #    0000000    0000000   000000000  000  000 0 000  000   000
    #    000   000  000       000   000  000  000  0000  000   000
    #    0000000    00000000  000   000  000  000   000  0000000  

    describe 'behind', () ->

        it 'should append the nodes view behind the dom', () ->
            parent = getTag 'div'
            node   = new Node tag:'div'
            parent.appendChild getTag 'div'
            parent.appendChild prev = getTag 'div'
            parent.appendChild getTag 'div'
            node.behind prev
            expect(parent.childNodes[2]).to.equal node.view
            expect(parent.childNodes.length).to.equal 4

        it 'should append the nodes view behind the dom if the dom is the last child', () ->
            parent = getTag 'div'
            node   = new Node tag:'div'
            parent.appendChild getTag 'div'
            parent.appendChild getTag 'div'
            parent.appendChild prev = getTag 'div'
            node.behind prev
            expect(parent.childNodes[3]).to.equal node.view
            expect(parent.childNodes.length).to.equal 4

        it 'should throw an error if the doms parent is controlled by a node', () ->
            checkDom = Node.CHECK_DOM
            Node.CHECK_DOM = true
            parent = new Node tag:'div'
            node   = new Node tag:'div'
            parent.view.appendChild prev = getTag 'div'
            expect(() -> node.behind prev).to.throw()
            Node.CHECK_DOM = checkDom

        it 'should not throw an error if Node.CHECK_DOM = false', () ->
            checkDom = Node.CHECK_DOM
            Node.CHECK_DOM = false
            parent = new Node tag:'div'
            node   = new Node tag:'div'
            parent.view.appendChild prev = getTag 'div'
            expect(() -> node.behind prev).to.not.throw()
            Node.CHECK_DOM = true
            Node.CHECK_DOM = checkDom


    #    0000000    00000000  00000000   0000000   00000000   00000000
    #    000   000  000       000       000   000  000   000  000     
    #    0000000    0000000   000000    000   000  0000000    0000000 
    #    000   000  000       000       000   000  000   000  000     
    #    0000000    00000000  000        0000000   000   000  00000000

    describe 'before', () ->

        it 'should prepand the nodes view before the dom', () ->
            parent = getTag 'div'
            node   = new Node tag:'div'
            parent.appendChild getTag 'div'
            parent.appendChild next = getTag 'div'
            node.before next
            expect(parent.childNodes[1]).to.equal node.view
            expect(parent.childNodes.length).to.equal 3

        it 'should throw an error if the doms parent is controlled by a node', () ->
            checkDom = Node.CHECK_DOM
            Node.CHECK_DOM = true
            parent = new Node tag:'div'
            node   = new Node tag:'div'
            parent.view.appendChild next = getTag 'div'
            expect(() -> node.before next).to.throw()
            Node.CHECK_DOM = checkDom

        it 'should not throw an error if Node.CHECK_DOM = false', () ->
            checkDom = Node.CHECK_DOM
            Node.CHECK_DOM = false
            parent = new Node tag:'div'
            node   = new Node tag:'div'
            parent.view.appendChild next = getTag 'div'
            expect(() -> node.before next).to.not.throw()
            Node.CHECK_DOM = true
            Node.CHECK_DOM = checkDom


    #    00000000   00000000  00000000   000       0000000    0000000  00000000
    #    000   000  000       000   000  000      000   000  000       000     
    #    0000000    0000000   00000000   000      000000000  000       0000000 
    #    000   000  000       000        000      000   000  000       000     
    #    000   000  00000000  000        0000000  000   000   0000000  00000000

    describe 'replace', () ->

        it 'should replace the dom with the nodes view', () ->
            parent = getTag 'div'
            node   = new Node tag:'div'
            parent.appendChild old = getTag 'div'
            node.replace old
            expect(parent.childNodes[0]).to.equal node.view
            expect(parent.childNodes.length).to.equal 1

        it 'should throw an error if the doms parent is controlled by a node', () ->
            checkDom = Node.CHECK_DOM
            Node.CHECK_DOM = true
            parent = new Node tag:'div'
            node   = new Node tag:'div'
            parent.view.appendChild old = getTag 'div'
            expect(() -> node.replace old).to.throw()
            Node.CHECK_DOM = checkDom

        it 'should not throw an error for the doms parent if Node.CHECK_DOM = false', () ->
            checkDom = Node.CHECK_DOM
            Node.CHECK_DOM = false
            parent = new Node tag:'div'
            node   = new Node tag:'div'
            parent.view.appendChild old = getTag 'div'
            expect(() -> node.replace old).to.not.throw()
            Node.CHECK_DOM = checkDom

        it 'should throw an error if the dom is controlled by a node', () ->
            checkDom = Node.CHECK_DOM
            Node.CHECK_DOM = true
            parent = getTag 'div'
            node   = new Node tag:'div'
            parent.appendChild old = (new Node tag:'div').view
            expect(() -> node.replace old).to.throw()
            Node.CHECK_DOM = checkDom

        it 'should not throw an error for the dom if Node.CHECK_DOM = false', () ->
            checkDom = Node.CHECK_DOM
            Node.CHECK_DOM = false
            parent = getTag 'div'
            node   = new Node tag:'div'
            parent.appendChild old = (new Node tag:'div').view
            expect(() -> node.replace old).to.not.throw()
            Node.CHECK_DOM = checkDom


    describe 'remove', () ->

        it 'should remove the nodes view from the dom', () ->
            parent = getTag 'div'
            node   = new Node tag:'div'
            node.appendTo parent
            node.remove()
            expect(parent.childNodes.length).to.equal 0

        it 'should throw an error if the doms parent is controlled by a node', () ->
            checkDom = Node.CHECK_DOM
            Node.CHECK_DOM = true
            parent = new Node tag:'div'
            node   = new Node tag:'div'
            parent.addChild node
            expect(() -> node.remove()).to.throw()
            Node.CHECK_DOM = checkDom

        it 'should not throw an error for the doms parent if Node.CHECK_DOM = false', () ->
            checkDom = Node.CHECK_DOM
            Node.CHECK_DOM = false
            parent = new Node tag:'div'
            node   = new Node tag:'div'
            parent.view.appendChild node.view
            expect(() -> node.remove()).to.not.throw()
            Node.CHECK_DOM = checkDom




    #     0000000   0000000    0000000     0000t000  000   000  000  000      0000000
    #    000   000  000   000  000   000  000       000   000  000  000      000   000
    #    000000000  000   000  000   000  000       000000000  000  000      000   000
    #    000   000  000   000  000   000  000       000   000  000  000      000   000
    #    000   000  0000000    0000000     0000000  000   000  000  0000000  0000000  

    describe 'addChild', () ->

        it 'should add a child node', () ->
            child  = new Node tag:'div'
            parent = new Node tag:'div'
            parent.addChild child
            expect(parent.children[0]).to.equal child


        it 'should add a child node', () ->
            child  = new Node tag:'div'
            parent = new Node tag:'div'
            parent.addChild child
            expect(parent.children[0]).to.equal child




    #    00000000   00000000  00     00   0000000   000   000  00000000   0000000  000   000  000  000      0000000  
    #    000   000  000       000   000  000   000  000   000  000       000       000   000  000  000      000   000
    #    0000000    0000000   000000000  000   000   000 000   0000000   000       000000000  000  000      000   000
    #    000   000  000       000 0 000  000   000     000     000       000       000   000  000  000      000   000
    #    000   000  00000000  000   000   0000000       0      00000000   0000000  000   000  000  0000000  0000000  

    describe 'removeChild', () ->

        it 'should remove a child node', () ->
            child  = new Node tag:'div'
            parent = new Node tag:'div'
            parent.addChild child
            parent.removeChild child
            expect(parent.children.length).to.equal 0




#     0000000  000       0000000    0000000   0000000        000   000   0000000   00     00  00000000
#    000       000      000   000  000       000             0000  000  000   000  000   000  000     
#    000       000      000000000  0000000   0000000         000 0 000  000000000  000000000  0000000 
#    000       000      000   000       000       000        000  0000  000   000  000 0 000  000     
#     0000000  0000000  000   000  0000000   0000000         000   000  000   000  000   000  00000000

describe 'className', () ->


    #     0000000    0000000         0000000   0000000          000  00000000   0000000  000000000
    #    000   000  000             000   000  000   000        000  000       000          000   
    #    000000000  0000000         000   000  0000000          000  0000000   000          000   
    #    000   000       000        000   000  000   000  000   000  000       000          000   
    #    000   000  0000000          0000000   0000000     0000000   00000000   0000000     000   

    describe 'as object', () ->

        it 'should have the classes test-a and test-b', () ->
            node = new Node
                tag:       'div'
                className:
                    'test-a':true
                    'test-b':true

            cl = node.view.classList
            expect(cl.contains 'test-a').to.equal true
            expect(cl.contains 'test-b').to.equal true

        it 'should have the classes test-a and not test-b', () ->
            node = new Node
                tag:       'div'
                className:
                    'test-a':true
                    'test-b':false

            cl = node.view.classList
            expect(cl.contains 'test-a').to.equal true
            expect(cl.contains 'test-b').to.equal false

        it 'should have the class test-a after removing test-b', () ->
            cfg =
                tag: 'div'
                className:
                    'test-a': true
                    'test-b': true

            node = new Node cfg
            cl   = node.view.classList
            cfg.className =
                'test-a': true
                'test-b': false
            node.updateNow()
            expect(cl.contains 'test-a').to.equal true
            expect(cl.contains 'test-b').to.equal false

        it 'should have the classes test-a and test-c after removing test-b', () ->
            cfg =
                tag: 'div'
                className:
                    'test-a': true
                    'test-b': true

            node = new Node cfg
            cl   = node.view.classList
            cfg.className =
                'test-a': true
                'test-c': true

            node.updateNow()
            expect(cl.contains 'test-a').to.equal true
            expect(cl.contains 'test-b').to.equal false
            expect(cl.contains 'test-c').to.equal true


    #     0000000    0000000         0000000   00000000   00000000    0000000   000   000
    #    000   000  000             000   000  000   000  000   000  000   000   000 000 
    #    000000000  0000000         000000000  0000000    0000000    000000000    00000  
    #    000   000       000        000   000  000   000  000   000  000   000     000   
    #    000   000  0000000         000   000  000   000  000   000  000   000     000   

    describe 'as array', () ->

        it 'should have the classes test-a and test-b', () ->
            node = new Node
                tag:       'div'
                className: [
                    ['test-a', true]
                    ['test-b', true]
                ]

            cl = node.view.classList
            expect(cl.contains 'test-a').to.equal true
            expect(cl.contains 'test-b').to.equal true

        it 'should have the classes test-a and not test-b', () ->
            node = new Node
                tag:       'div'
                className: [
                    ['test-a', true]
                    ['test-b', false]
                ]

            cl = node.view.classList
            expect(cl.contains 'test-a').to.equal true
            expect(cl.contains 'test-b').to.equal false

        it 'should have the class test-a after removing test-b', () ->
            cfg =
                tag:       'div'
                className: [
                    ['test-a', true]
                    ['test-b', true]
                ]

            node = new Node cfg
            cl   = node.view.classList
            cfg.className[1][1] = false
            node.updateNow()
            expect(cl.contains 'test-a').to.equal true
            expect(cl.contains 'test-b').to.equal false

        it 'should have the classes test-a and test-c after removing test-b', () ->
            cfg =
                tag:       'div'
                className: [
                    ['test-a', true]
                    ['test-b', true]
                ]

            node = new Node cfg
            cl   = node.view.classList
            cfg.className[1][0] = 'test-c'
            node.updateNow()
            expect(cl.contains 'test-a').to.equal true
            expect(cl.contains 'test-b').to.equal false
            expect(cl.contains 'test-c').to.equal true




#    000   000  00000000   0000000     0000000   000000000  00000000        000000000  00000000  000   000  000000000         0000000  000   000  000  000      0000000  
#    000   000  000   000  000   000  000   000     000     000                000     000        000 000      000           000       000   000  000  000      000   000
#    000   000  00000000   000   000  000000000     000     0000000            000     0000000     00000       000           000       000000000  000  000      000   000
#    000   000  000        000   000  000   000     000     000                000     000        000 000      000           000       000   000  000  000      000   000
#     0000000   000        0000000    000   000     000     00000000           000     00000000  000   000     000            0000000  000   000  000  0000000  0000000  

describe 'update text child', () ->

    it 'should update the string value of a text child', () ->
        cfg =
            tag:  'div'
            text: 'hello'
        node = new Node cfg
        expectTextNode node.children[0], Node, 'hello'
        cfg.text = 'world'
        node.updateNow()
        expectTextNode node.children[0], Node, 'world'

    it 'should update the number value of a text child', () ->
        cfg =
            tag:  'div'
            text: 1
        node = new Node cfg
        expectTextNode node.children[0], Node, 1
        cfg.text = 2
        node.updateNow()
        expectTextNode node.children[0], Node, 2

    it 'should update the boolean value of a text child', () ->
        cfg =
            tag:  'div'
            text: true
        node = new Node cfg
        expectTextNode node.children[0], Node, true
        cfg.text = false
        node.updateNow()
        expectTextNode node.children[0], Node, false




describe 'callbacks', () ->

    describe 'onMount', () ->

        it 'should be called, if node is added to another node', () ->
            node   = new MyCallbackNode()
            new Node { tag: 'div', child: node }
            expect(node.called['onMount']).to.equal true

        it 'should be called, if node replaces another node', () ->
            node   = new MyCallbackNode()
            other  = new Node tag: 'div'
            parent = new Node { tag: 'div', child: other }
            parent.replaceChild other, node
            expect(node.called['onMount']).to.equal true

    describe 'onMount', () ->

        it 'should be called, if node is removed from another node', () ->
            node   = new MyCallbackNode()
            parent = new Node { tag: 'div', child: node }
            parent.removeChild node
            expect(node.called['onUnmount']).to.equal true

        it 'should be called, if node is replaced by another node', () ->
            node   = new MyCallbackNode()
            other  = new Node tag: 'div'
            parent = new Node { tag: 'div', child: node }
            parent.replaceChild node, other
            expect(node.called['onUnmount']).to.equal true




describe 'update', () ->

    describe 'if child is same class as cfg.tag', () ->

        it 'should inject from the new cfg', () ->

            children = [
                tag: MyValidNode
                inject:
                    test: 'hello world'
            ]
            parent = new Node
                tag:      'div'
                children: children

            child = parent.children[0]
            expect(child.test).to.equal 'hello world'
            children[0] =
                tag: MyValidNode
                inject:
                    test: 'hello world!!!'
            parent.updateNow()
            expect(parent.children[0]).to.equal child
            expect(child.test).to.equal 'hello world!!!'

describe 'cfg.updateChildren = false', () ->

    it 'should not update children if parent is updated', () ->

        parent = new Node
            tag:      'div'
            children: [
                tag:      'div'
                disabled: true
            ]

        expect(parent.children[0].attrs.disabled).to.equal true
        parent.cfg.children[0].disabled = false
        parent.updateNow()
        expect(parent.children[0].attrs.disabled).to.equal false
        parent.cfg.children[0].disabled = true
        parent.cfg.updateChildren = false
        parent.updateNow()
        expect(parent.children[0].attrs.disabled).to.equal false


    it 'should not update text if parent is updated', () ->

        parent = new Node
            tag:  'div'
            text: 'test'

        expectTextNode parent.children[0], Node, 'test'
        parent.cfg.text = 'test!'
        parent.updateNow()
        expectTextNode parent.children[0], Node, 'test!'
        parent.cfg.text = 'test!!'
        parent.cfg.updateChildren = false
        parent.updateNow()
        expectTextNode parent.children[0], Node, 'test!'



    it 'should not update child if parent is updated', () ->

        parent = new Node
            tag:      'div'
            child:
                tag:      'div'
                disabled: true

        expect(parent.children[0].attrs.disabled).to.equal true
        parent.cfg.child.disabled = false
        parent.updateNow()
        expect(parent.children[0].attrs.disabled).to.equal false
        parent.cfg.child.disabled = true
        parent.cfg.updateChildren = false
        parent.updateNow()
        expect(parent.children[0].attrs.disabled).to.equal false