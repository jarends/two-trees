// Generated by CoffeeScript 1.12.6
(function() {
  var COMP_CFG_ERR, ExtendedMockNode, MockNode, Node, VIEW_CFG_ERR, ViewTree, WrongViewCfgNode, create, expectNode, expectTag, expectText, expectType,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  ViewTree = require('../../src/js/view-tree');

  Node = ViewTree.Node;

  create = ViewTree.create;

  COMP_CFG_ERR = ViewTree.COMP_CFG_ERROR;

  VIEW_CFG_ERR = ViewTree.VIEW_CFG_ERROR;

  MockNode = (function(superClass) {
    extend(MockNode, superClass);

    function MockNode() {
      return MockNode.__super__.constructor.apply(this, arguments);
    }

    MockNode.prototype.render = function() {
      return {
        tag: 'mock-node'
      };
    };

    return MockNode;

  })(Node);

  ExtendedMockNode = (function(superClass) {
    extend(ExtendedMockNode, superClass);

    function ExtendedMockNode() {
      return ExtendedMockNode.__super__.constructor.apply(this, arguments);
    }

    return ExtendedMockNode;

  })(MockNode);

  WrongViewCfgNode = (function(superClass) {
    extend(WrongViewCfgNode, superClass);

    function WrongViewCfgNode(cfg) {
      this.cfg = cfg;
    }

    WrongViewCfgNode.prototype.render = function() {
      return {
        tag: this.cfg.value
      };
    };

    return WrongViewCfgNode;

  })(Node);

  ViewTree.map('mock', MockNode);

  expectNode = function(node, clazz) {
    if (clazz == null) {
      clazz = Node;
    }
    expect(node).to.be["instanceof"](clazz);
    return expect(node.view).to.be.ok;
  };

  expectType = function(node, type) {
    expectNode(node);
    return expect(node.view.nodeType).to.equal(type);
  };

  expectText = function(node, text) {
    expectType(node, 3);
    return expect(node.view.nodeValue).to.equal(text);
  };

  expectTag = function(node, tag) {
    expectType(node, 1);
    return expect(node.view.nodeName.toUpperCase()).to.equal(tag.toUpperCase());
  };

  describe('TreeOne', function() {
    return describe('create', function() {
      it('should throw a comp cfg error if cfg is null or undefined', function() {
        expect(function() {
          return create(null);
        }).to["throw"]();
        return expect(function() {
          return create(void 0);
        }).to["throw"]();
      });
      it('should throw a comp cfg error if cfg.tag is neither a not empty string nor a component class', function() {
        expect(function() {
          return create({
            tag: null
          });
        }).to["throw"](COMP_CFG_ERR);
        expect(function() {
          return create({
            tag: void 0
          });
        }).to["throw"](COMP_CFG_ERR);
        expect(function() {
          return create({
            tag: ''
          });
        }).to["throw"](COMP_CFG_ERR);
        expect(function() {
          return create({
            tag: []
          });
        }).to["throw"](COMP_CFG_ERR);
        expect(function() {
          return create({
            tag: {}
          });
        }).to["throw"](COMP_CFG_ERR);
        expect(function() {
          return create({
            tag: function() {}
          });
        }).to["throw"](COMP_CFG_ERR);
        expect(function() {
          return create({
            tag: 'a'
          });
        }).to.not["throw"]();
        expect(function() {
          return create({
            tag: MockNode
          });
        }).to.not["throw"]();
        return expect(function() {
          return create({
            tag: ExtendedMockNode
          });
        }).to.not["throw"]();
      });
      it('should throw a view cfg error if cfg returned by node.render() isn\'t a not empty string', function() {
        expect(function() {
          return create({
            tag: WrongViewCfgNode,
            value: null
          });
        }).to["throw"](VIEW_CFG_ERR);
        expect(function() {
          return create({
            tag: WrongViewCfgNode,
            value: void 0
          });
        }).to["throw"](VIEW_CFG_ERR);
        expect(function() {
          return create({
            tag: WrongViewCfgNode,
            value: ''
          });
        }).to["throw"](VIEW_CFG_ERR);
        expect(function() {
          return create({
            tag: WrongViewCfgNode,
            value: []
          });
        }).to["throw"](VIEW_CFG_ERR);
        expect(function() {
          return create({
            tag: WrongViewCfgNode,
            value: {}
          });
        }).to["throw"](VIEW_CFG_ERR);
        expect(function() {
          return create({
            tag: WrongViewCfgNode,
            value: function() {}
          });
        }).to["throw"](VIEW_CFG_ERR);
        return expect(function() {
          return create({
            tag: WrongViewCfgNode,
            value: MockNode
          });
        }).to["throw"](VIEW_CFG_ERR);
      });
      it('should return a text node', function() {
        expectText(create('hello'), 'hello');
        expectText(create(0), '0');
        return expectText(create(true), 'true');
      });
      it('should return a basic node with given tag', function() {
        return expectTag(create({
          tag: 'hello'
        }), 'hello');
      });
      it('should return a component node', function() {
        expectNode(create({
          tag: MockNode
        }), MockNode);
        return expectTag(create({
          tag: MockNode
        }), 'mock-node');
      });
      return it('should return a mapped node', function() {
        expectNode(create({
          tag: 'mock'
        }), MockNode);
        return expectTag(create({
          tag: 'mock'
        }), 'mock-node');
      });
    });
  });

}).call(this);

//# sourceMappingURL=view-tree.js.map
