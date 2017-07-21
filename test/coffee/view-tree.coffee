ViewTree = require '../../src/js/view-tree'
Node     = ViewTree.Node


class MockNode extends Node
    render: () -> tag: 'mock-node'


class ExtendedMockNode extends MockNode


ViewTree.map 'mock', MockNode


create = ViewTree.create


expectNode = (node, clazz = Node) ->
    expect(node).to.be.instanceof clazz
    expect(node.view).to.be.ok


expectType = (node, type) ->
    expectNode(node)
    expect(node.view.nodeType).to.equal type


expectText = (node, text) ->
    expectType node, 3
    expect(node.view.nodeValue).to.equal text + ''


expectTag = (node, tag) ->
    expectType node, 1
    expect(node.view.nodeName.toUpperCase()).to.equal tag.toUpperCase()




describe 'TreeOne', () ->

    describe 'create', () ->

        it 'should throw an error if cfg is null or undefined', () ->
            expect(() -> create null).to.throw()
            expect(() -> create undefined).to.throw()

        it 'should throw an error if cfg.tag is neither a not empty string nor a component class', () ->
            expect(() -> create tag: null)            .to.throw()
            expect(() -> create tag: undefined)       .to.throw()
            expect(() -> create tag: '')              .to.throw()
            expect(() -> create tag: [])              .to.throw()
            expect(() -> create tag: {})              .to.throw()
            expect(() -> create tag: () ->)           .to.throw()
            expect(() -> create tag: 'a')             .to.not.throw()
            expect(() -> create tag: MockNode)        .to.not.throw()
            expect(() -> create tag: ExtendedMockNode).to.not.throw()

        it 'should return a text node', () ->
            expectText create('hello'), 'hello'
            expectText create(0),       0
            expectText create(true),    true

        it 'should return a basic node with given tag', () ->
            expectTag create(tag: 'hello'), 'hello'

        it 'should return a component node', () ->
            expectNode create(tag: MockNode), MockNode
            expectTag  create(tag: MockNode), 'mock-node'

        it 'should return a mapped node', () ->
            expectNode create(tag: 'mock'), MockNode
            expectTag  create(tag: MockNode), 'mock-node'
