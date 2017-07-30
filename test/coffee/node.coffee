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
    expect(node.view.nodeValue).to.equal(text + '')
    expect(node.text).to.equal(text)


expectValidTagNode = (node, clazz, tag) ->
    expectClass   node, clazz
    expectExtends node.view, HTMLElement
    expect(node.view.nodeName.toLowerCase()).to.equal(tag)
    expect(node.tag).to.equal(tag)


expectAttr = (node, name, value) ->
    expectExtends node.view, HTMLElement
    value = Node.getOrCall value
    expect(node.attrs[name]).to.equal value
    expect(node.view.getAttribute(name)).to.equal value + ''


expectBoolAttr = (node, name, value) ->
    expectExtends node.view, HTMLElement
    value = Node.getOrCall value
    expect(node.attrs[name]).to.equal value
    if value == true
        expect(node.view.getAttribute(name)).to.equal ''
        expect(node.view[name]).to.equal true
    else
        expect(node.view.getAttribute(name)).to.equal null
        expect(node.view[name]).to.equal false




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


    it "should create a bool attr disabled = false", () ->
        cfg =
            tag:      'div'
            disabled: false
        expectValidTagNode node = new Node(cfg), Node, 'div'
        expectBoolAttr node, 'disabled', false









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
