ViewTree = require '../../src/js/view-tree'
Node     = ViewTree.Node


create       = ViewTree.create
COMP_CFG_ERR = ViewTree.COMP_CFG_ERROR
VIEW_CFG_ERR = ViewTree.VIEW_CFG_ERROR


class MockNode extends Node
    render: () -> tag: 'mock-node'

class ExtendedMockNode extends MockNode

class WrongViewCfgNode extends Node
    constructor: (@cfg) ->
    render: () -> tag: @cfg.value


ViewTree.map 'mock', MockNode


expectNode = (node, clazz = Node) ->
    expect(node).to.be.instanceof clazz
    expect(node.view).to.be.ok


expectType = (node, type) ->
    expectNode(node)
    expect(node.view.nodeType).to.equal type


expectText = (node, text) ->
    expectType node, 3
    expect(node.view.nodeValue).to.equal text


expectTag = (node, tag) ->
    expectType node, 1
    expect(node.view.nodeName.toUpperCase()).to.equal tag.toUpperCase()




describe 'TreeOne', () ->


    describe 'create', () ->

        it 'should throw a comp cfg error if cfg is null or undefined', () ->
            expect(() -> create null).to.throw()
            expect(() -> create undefined).to.throw()

        it 'should throw a comp cfg error if cfg.tag is neither a not empty string nor a component class', () ->
            expect(() -> create tag: null)            .to.throw(COMP_CFG_ERR)
            expect(() -> create tag: undefined)       .to.throw(COMP_CFG_ERR)
            expect(() -> create tag: '')              .to.throw(COMP_CFG_ERR)
            expect(() -> create tag: [])              .to.throw(COMP_CFG_ERR)
            expect(() -> create tag: {})              .to.throw(COMP_CFG_ERR)
            expect(() -> create tag: () ->)           .to.throw(COMP_CFG_ERR)
            expect(() -> create tag: 'a')             .to.not.throw()
            expect(() -> create tag: MockNode)        .to.not.throw()
            expect(() -> create tag: ExtendedMockNode).to.not.throw()

        it 'should throw a view cfg error if cfg returned by node.render() isn\'t a not empty string', () ->
            expect(() -> create {tag: WrongViewCfgNode, value: null})     .to.throw(VIEW_CFG_ERR)
            expect(() -> create {tag: WrongViewCfgNode, value: undefined}).to.throw(VIEW_CFG_ERR)
            expect(() -> create {tag: WrongViewCfgNode, value: ''})       .to.throw(VIEW_CFG_ERR)
            expect(() -> create {tag: WrongViewCfgNode, value: []})       .to.throw(VIEW_CFG_ERR)
            expect(() -> create {tag: WrongViewCfgNode, value: {}})       .to.throw(VIEW_CFG_ERR)
            expect(() -> create {tag: WrongViewCfgNode, value: () ->})    .to.throw(VIEW_CFG_ERR)
            expect(() -> create {tag: WrongViewCfgNode, value: MockNode}) .to.throw(VIEW_CFG_ERR)

        it 'should return a text node', () ->
            expectText create('hello'), 'hello'
            expectText create(0),       '0'
            expectText create(true),    'true'

        it 'should return a basic node with given tag', () ->
            expectTag create(tag: 'hello'), 'hello'

        it 'should return a component node', () ->
            expectNode create(tag: MockNode), MockNode
            expectTag  create(tag: MockNode), 'mock-node'

        it 'should return a mapped node', () ->
            expectNode create(tag: 'mock'), MockNode
            expectTag  create(tag: 'mock'), 'mock-node'
