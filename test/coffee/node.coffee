Node = require '../../src/js/node'


getTag  = (tag)  -> document.createElement  tag
getText = (text) -> document.createTextNode text

class MyValidNode extends Node
    render: () -> tag: 'div'

class MyTextNode1 extends Node
    render: () -> 'text'

class MyTextNode2 extends Node
    render: () -> text: 'text'

class MyExtendedNode extends Node




expectClass   = (node, clazz) -> expect(node.constructor).to.equal clazz
expectExtends = (node, clazz) -> expect(node).to.be.instanceof clazz


expectValidTextNode = (node, clazz, text) ->
    expectClass   node, clazz
    expectExtends node.view, Text
    expect(node.kind).to.equal Node.TEXT_KIND
    expect(node.view.nodeValue).to.equal text + ''
    expect(node.text).to.equal text


expectValidTagNode = (node, clazz, tag) ->
    expectClass   node, clazz
    expectExtends node.view, HTMLElement
    expect(node.kind).to.equal Node.TAG_KIND
    expect(node.view.nodeName.toLowerCase()).to.equal tag
    expect(node.tag).to.equal tag


expectAttr = (node, name, value) ->
    expectExtends node.view, HTMLElement
    expect(node.kind).to.equal Node.TAG_KIND
    expect(node.attrs[name]).to.equal value = Node.getOrCall value
    expect(node.view.getAttribute(name)).to.equal value + ''


expectBoolAttr = (node, name, value) ->
    expectExtends node.view, HTMLElement
    expect(node.attrs[name]).to.equal value = Node.getOrCall value
    if value == true
        expect(node.view.getAttribute(name)).to.equal ''
        expect(node.view[name]).to.equal value
    else
        expect(node.view.getAttribute(name)).to.equal null
        expect(node.view[name]).to.equal value








describe 'Node', () ->

    describe '.create', () ->

        it "should return a valid text node, if cfg = 'text'", () ->
            expectValidTextNode Node.create('text'), Node, 'text'

        it "should return a valid text node, if cfg = Text", () ->
            expectValidTextNode Node.create(getText('text')), Node, 'text'

        it "should return a valid text node, if cfg.text = 'text'", () ->
            expectValidTextNode Node.create(text: 'text'), Node, 'text'

        it "should return a valid text node, if cfg.tag = Text", () ->
            expectValidTextNode Node.create(tag: getText('text')), Node, 'text'

        it "should return a valid text node, if cfg.clazz = MyTextNode1", () ->
            expectValidTextNode Node.create(clazz: MyTextNode1), MyTextNode1, 'text'

        it "should return a valid text node, if cfg.clazz = MyTextNode2", () ->
            expectValidTextNode Node.create(clazz: MyTextNode2), MyTextNode2, 'text'

        it "should return a valid tag node, if cfg = HTMLELement", () ->
            expectValidTagNode Node.create(getTag('div')), Node, 'div'

        it "should return a valid tag node, if cfg.tag = 'div'", () ->
            expectValidTagNode Node.create(tag:'div'), Node, 'div'

        it "should return a valid tag node, if cfg.tag = HTMLELement", () ->
            expectValidTagNode Node.create(tag: getTag('div')), Node, 'div'

        it "should return a valid tag node, if cfg.tag = MyValidNode", () ->
            expectValidTagNode Node.create(tag: MyValidNode), MyValidNode, 'div'

        it "should return a valid tag node, if cfg.clazz = MyValidNode", () ->
            expectValidTagNode Node.create(clazz: MyValidNode), MyValidNode, 'div'

        it "should throw an error, if cfg = null", () ->
            expect(() -> Node.create()).to.throw()

        it "should throw an error, if neither tag nor text are set", () ->
            expect(() -> Node.create  {}).to.throw()

        it "should throw an error, if cfg.tag = MyExtendedNode", () ->
            expect(() -> Node.create(tag: MyExtendedNode)).to.throw()

        it "should throw an error, if cfg.tag is invalid", () ->
            expect(() -> Node.create tag: 1).to.throw()
            expect(() -> Node.create tag: true).to.throw()
            expect(() -> Node.create tag: {}).to.throw()
            expect(() -> Node.create tag: []).to.throw()
            expect(() -> Node.create tag: () ->).to.throw()

        it "should throw an error, if cfg.text is invalid", () ->
            expect(() -> Node.create text: null).to.throw()
            expect(() -> Node.create text: {}).to.throw()
            expect(() -> Node.create text: []).to.throw()
            expect(() -> Node.create text: () ->).to.throw()
            expect(() -> Node.create text: () -> {}).to.throw()
            expect(() -> Node.create text: () -> []).to.throw()

        it "should throw an error, if cfg.clazz = MyExtendedNode, because neither tag nor text are set", () ->
            expect(() -> Node.create(clazz: MyExtendedNode)).to.throw()

        it "should not throw an error, if cfg.clazz = MyExtendedNode and tag = 'div'", () ->
            expect(() -> Node.create({tag: 'div', clazz: MyExtendedNode})).to.not.throw()

        it "should not throw an error, if cfg.clazz = MyExtendedNode and text = ''", () ->
            expect(() -> Node.create({text: '', clazz: MyExtendedNode})).to.not.throw()

        it "should not throw an error, if cfg.text is valid", () ->
            expect(() -> expectValidTextNode Node.create(text: ''),         Node, '')   .to.not.throw()
            expect(() -> expectValidTextNode Node.create(text: 1),          Node, 1)   .to.not.throw()
            expect(() -> expectValidTextNode Node.create(text: true),       Node, true).to.not.throw()
            expect(() -> expectValidTextNode Node.create(text: () -> ''),   Node, '')  .to.not.throw()
            expect(() -> expectValidTextNode Node.create(text: () -> 1),    Node, 1)   .to.not.throw()
            expect(() -> expectValidTextNode Node.create(text: () -> true), Node, true).to.not.throw()




describe 'new Node', () ->

    it "should return a valid text node, if cfg = 'text'", () ->
        expectValidTextNode new Node('text'), Node, 'text'

    it "should return a valid text node, if cfg = Text", () ->
        expectValidTextNode new Node(getText('text')), Node, 'text'

    it "should return a valid text node, if cfg.text = 'text'", () ->
        expectValidTextNode new Node(text: 'text'), Node, 'text'

    it "should return a valid text node, if cfg.tag = Text", () ->
        expectValidTextNode new Node(tag: getText('text')), Node, 'text'

    it "should return a valid tag node, if cfg = HTMLELement", () ->
        expectValidTagNode new Node(getTag('div')), Node, 'div'

    it "should return a valid tag node, if cfg.tag = 'div'", () ->
        expectValidTagNode new Node(tag:'div'), Node, 'div'

    it "should return a valid tag node, if cfg.tag = HTMLELement", () ->
        expectValidTagNode new Node(tag: getTag('div')), Node, 'div'

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
        expect(() -> new Node text: null).to.throw()
        expect(() -> new Node text: {}).to.throw()
        expect(() -> new Node text: []).to.throw()
        expect(() -> new Node text: () ->).to.throw()
        expect(() -> new Node text: () -> {}).to.throw()
        expect(() -> new Node text: () -> []).to.throw()

    it "should not throw an error, if cfg.text is valid", () ->
        expect(() -> expectValidTextNode new Node(text: ''),         Node, '')   .to.not.throw()
        expect(() -> expectValidTextNode new Node(text: 1),          Node, 1)   .to.not.throw()
        expect(() -> expectValidTextNode new Node(text: true),       Node, true).to.not.throw()
        expect(() -> expectValidTextNode new Node(text: () -> ''),   Node, '')  .to.not.throw()
        expect(() -> expectValidTextNode new Node(text: () -> 1),    Node, 1)   .to.not.throw()
        expect(() -> expectValidTextNode new Node(text: () -> true), Node, true).to.not.throw()

    it "should create a attr title = 'my title'", () ->
        cfg =
            tag:   'div'
            title: 'my title'
        expectValidTagNode node = new Node(cfg), Node, 'div'
        expectAttr node, 'title', 'my title'

    it "should create a bool attr disabled = true", () ->
        cfg =
            tag:      'div'
            disabled: true
        expectValidTagNode node = new Node(cfg), Node, 'div'
        expectBoolAttr node, 'disabled', true

    it "should create a bool attr disabled = false", () ->
        cfg =
            tag:      'div'
            disabled: false
        expectValidTagNode node = new Node(cfg), Node, 'div'
        expectBoolAttr node, 'disabled', false

    it "should remove a bool attr disabled = undefined", () ->
        cfg =
            tag:      'div'
            disabled: undefined
        expectValidTagNode node = new Node(cfg), Node, 'div'
        expectBoolAttr node, 'disabled', undefined




describe 'node instance', () ->

    describe 'appendTo', () ->

        it 'should append the nodes view to the dom', () ->
            parent = getTag 'div'
            node   = new Node tag:'div'
            node.appendTo parent
            expect(parent.childNodes[0]).to.equal node.view
            expect(parent.childNodes.length).to.equal 1

        it 'should throw an error if the dom is controlled by a node', () ->
            parent = new Node tag:'div'
            node   = new Node tag:'div'
            expect(() -> node.appendTo parent.view).to.throw()

        it 'should not throw an error if Node.CHECK_DOM = false', () ->
            Node.CHECK_DOM = false
            parent = new Node tag:'div'
            node   = new Node tag:'div'
            expect(() -> node.appendTo parent.view).to.not.throw()
            Node.CHECK_DOM = true


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
            parent = new Node tag:'div'
            node   = new Node tag:'div'
            parent.view.appendChild prev = getTag 'div'
            expect(() -> node.behind prev).to.throw()


        it 'should not throw an error if Node.CHECK_DOM = false', () ->
            Node.CHECK_DOM = false
            parent = new Node tag:'div'
            node   = new Node tag:'div'
            parent.view.appendChild prev = getTag 'div'
            expect(() -> node.behind prev).to.not.throw()
            Node.CHECK_DOM = true


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
            parent = new Node tag:'div'
            node   = new Node tag:'div'
            parent.view.appendChild next = getTag 'div'
            expect(() -> node.before next).to.throw()


        it 'should not throw an error if Node.CHECK_DOM = false', () ->
            Node.CHECK_DOM = false
            parent = new Node tag:'div'
            node   = new Node tag:'div'
            parent.view.appendChild next = getTag 'div'
            expect(() -> node.before next).to.not.throw()
            Node.CHECK_DOM = true


    describe 'replace', () ->

        it 'should replace the dom with the nodes view', () ->
            parent = getTag 'div'
            node   = new Node tag:'div'
            parent.appendChild old = getTag 'div'
            node.replace old
            expect(parent.childNodes[0]).to.equal node.view
            expect(parent.childNodes.length).to.equal 1


        it 'should throw an error if the doms parent is controlled by a node', () ->
            parent = new Node tag:'div'
            node   = new Node tag:'div'
            parent.view.appendChild old = getTag 'div'
            expect(() -> node.replace old).to.throw()


        it 'should not throw an error for the doms parent if Node.CHECK_DOM = false', () ->
            Node.CHECK_DOM = false
            parent = new Node tag:'div'
            node   = new Node tag:'div'
            parent.view.appendChild old = getTag 'div'
            expect(() -> node.replace old).to.not.throw()
            Node.CHECK_DOM = true


        it 'should throw an error if the dom is controlled by a node', () ->
            parent = getTag 'div'
            node   = new Node tag:'div'
            parent.appendChild old = (new Node tag:'div').view
            expect(() -> node.replace old).to.throw()

        it 'should not throw an error for the dom if Node.CHECK_DOM = false', () ->
            Node.CHECK_DOM = false
            parent = getTag 'div'
            node   = new Node tag:'div'
            parent.appendChild old = (new Node tag:'div').view
            expect(() -> node.replace old).to.not.throw()
            Node.CHECK_DOM = true


