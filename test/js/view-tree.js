// Generated by CoffeeScript 1.12.6
(function() {
  var MyExtendedNode, MyTextNode1, MyTextNode2, MyValidNode, Node, ViewTree, expectAttr, expectBoolAttr, expectClass, expectExtends, expectTagNode, expectTextNode, getTag, getText, updateNode,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  ViewTree = require('../../src/js/view-tree');

  Node = ViewTree.Node;

  getTag = function(tag) {
    return document.createElement(tag);
  };

  getText = function(text) {
    return document.createTextNode(text);
  };

  MyValidNode = (function(superClass) {
    extend(MyValidNode, superClass);

    function MyValidNode() {
      return MyValidNode.__super__.constructor.apply(this, arguments);
    }

    MyValidNode.prototype.render = function() {
      return {
        tag: 'div'
      };
    };

    return MyValidNode;

  })(Node);

  MyTextNode1 = (function(superClass) {
    extend(MyTextNode1, superClass);

    function MyTextNode1() {
      return MyTextNode1.__super__.constructor.apply(this, arguments);
    }

    MyTextNode1.prototype.render = function() {
      return 'text';
    };

    return MyTextNode1;

  })(Node);

  MyTextNode2 = (function(superClass) {
    extend(MyTextNode2, superClass);

    function MyTextNode2() {
      return MyTextNode2.__super__.constructor.apply(this, arguments);
    }

    MyTextNode2.prototype.render = function() {
      return {
        text: 'text'
      };
    };

    return MyTextNode2;

  })(Node);

  MyExtendedNode = (function(superClass) {
    extend(MyExtendedNode, superClass);

    function MyExtendedNode() {
      return MyExtendedNode.__super__.constructor.apply(this, arguments);
    }

    return MyExtendedNode;

  })(Node);

  updateNode = function(node) {
    if (Node.isNot(node.view)) {
      return node.updateNow();
    }
  };

  expectClass = function(node, clazz) {
    return expect(node.constructor).to.equal(clazz);
  };

  expectExtends = function(node, clazz) {
    return expect(node).to.be["instanceof"](clazz);
  };

  expectTextNode = function(node, clazz, text) {
    updateNode(node);
    expectClass(node, clazz);
    expectExtends(node.view, Text);
    expect(node.kind).to.equal(Node.TEXT_KIND);
    expect(node.view.nodeValue).to.equal(text + '');
    return expect(node.text).to.equal(text);
  };

  expectTagNode = function(node, clazz, tag) {
    updateNode(node);
    expectClass(node, clazz);
    expectExtends(node.view, HTMLElement);
    expect(node.kind).to.equal(Node.TAG_KIND);
    expect(node.view.nodeName.toLowerCase()).to.equal(tag);
    return expect(node.tag).to.equal(tag);
  };

  expectAttr = function(node, name, value) {
    expectExtends(node.view, HTMLElement);
    expect(node.kind).to.equal(Node.TAG_KIND);
    expect(node.attrs[name]).to.equal(value = Node.getOrCall(value));
    return expect(node.view.getAttribute(name)).to.equal(value + '');
  };

  expectBoolAttr = function(node, name, value) {
    updateNode(node);
    expectExtends(node.view, HTMLElement);
    expect(node.attrs[name]).to.equal(value = Node.getOrCall(value));
    if (value === true) {
      expect(node.view.getAttribute(name)).to.equal('');
      return expect(node.view[name]).to.equal(value);
    } else {
      expect(node.view.getAttribute(name)).to.equal(null);
      return expect(node.view[name]).to.equal(value);
    }
  };

  describe('Node', function() {
    return describe('.create', function() {
      it("should return a valid text node, if cfg = 'text'", function() {
        return expectTextNode(Node.create('text'), Node, 'text');
      });
      it("should return a valid text node, if cfg = Text", function() {
        return expectTextNode(Node.create(getText('text')), Node, 'text');
      });
      it("should return a valid text node, if cfg.text = 'text'", function() {
        return expectTextNode(Node.create({
          text: 'text'
        }), Node, 'text');
      });
      it("should return a valid text node, if cfg.tag = Text", function() {
        return expectTextNode(Node.create({
          tag: getText('text')
        }), Node, 'text');
      });
      it("should return a valid text node, if cfg.clazz = MyTextNode1", function() {
        return expectTextNode(Node.create({
          clazz: MyTextNode1
        }), MyTextNode1, 'text');
      });
      it("should return a valid text node, if cfg.clazz = MyTextNode2", function() {
        return expectTextNode(Node.create({
          clazz: MyTextNode2
        }), MyTextNode2, 'text');
      });
      it("should return a valid tag node, if cfg = HTMLELement", function() {
        return expectTagNode(Node.create(getTag('div')), Node, 'div');
      });
      it("should return a valid tag node, if cfg.tag = 'div'", function() {
        return expectTagNode(Node.create({
          tag: 'div'
        }), Node, 'div');
      });
      it("should return a valid tag node, if cfg.tag = HTMLELement", function() {
        return expectTagNode(Node.create({
          tag: getTag('div')
        }), Node, 'div');
      });
      it("should return a valid tag node, if cfg.tag = MyValidNode", function() {
        return expectTagNode(Node.create({
          tag: MyValidNode
        }), MyValidNode, 'div');
      });
      it("should return a valid tag node, if cfg.clazz = MyValidNode", function() {
        return expectTagNode(Node.create({
          clazz: MyValidNode
        }), MyValidNode, 'div');
      });
      it("should throw an error, if cfg = null", function() {
        return expect(function() {
          return Node.create();
        }).to["throw"]();
      });
      it("should throw an error, if neither tag nor text are set", function() {
        return expect(function() {
          return Node.create();
        }).to["throw"]();
      });
      it("should throw an error, if cfg.tag = MyExtendedNode", function() {
        return expect(function() {
          return Node.create({
            tag: MyExtendedNode
          });
        }).to["throw"]();
      });
      it("should throw an error, if cfg.tag is invalid", function() {
        expect(function() {
          return Node.create({
            tag: 1
          });
        }).to["throw"]();
        expect(function() {
          return Node.create({
            tag: true
          });
        }).to["throw"]();
        expect(function() {
          return Node.create({
            tag: {}
          });
        }).to["throw"]();
        expect(function() {
          return Node.create({
            tag: []
          });
        }).to["throw"]();
        return expect(function() {
          return Node.create({
            tag: function() {}
          });
        }).to["throw"]();
      });
      it("should throw an error, if cfg.text is invalid", function() {
        expect(function() {
          return Node.create({
            text: null
          });
        }).to["throw"]();
        expect(function() {
          return Node.create({
            text: {}
          });
        }).to["throw"]();
        expect(function() {
          return Node.create({
            text: []
          });
        }).to["throw"]();
        expect(function() {
          return Node.create({
            text: function() {}
          });
        }).to["throw"]();
        expect(function() {
          return Node.create({
            text: function() {
              return {};
            }
          });
        }).to["throw"]();
        return expect(function() {
          return Node.create({
            text: function() {
              return [];
            }
          });
        }).to["throw"]();
      });
      it("should throw an error, if cfg.clazz = MyExtendedNode, because neither tag nor text are set", function() {
        return expect(function() {
          return Node.create({
            clazz: MyExtendedNode
          });
        }).to["throw"]();
      });
      it("should not throw an error, if cfg.clazz = MyExtendedNode and tag = 'div'", function() {
        Node.create({
          tag: 'div',
          clazz: MyExtendedNode
        });
        return expect(function() {
          return Node.create({
            tag: 'div',
            clazz: MyExtendedNode
          });
        }).to.not["throw"]();
      });
      it("should not throw an error, if cfg.clazz = MyExtendedNode and text = ''", function() {
        return expect(function() {
          return Node.create({
            text: '',
            clazz: MyExtendedNode
          });
        }).to.not["throw"]();
      });
      return it("should not throw an error, if cfg.text is valid", function() {
        expect(function() {
          return expectTextNode(Node.create({
            text: ''
          }), Node, '');
        }).to.not["throw"]();
        expect(function() {
          return expectTextNode(Node.create({
            text: 1
          }), Node, 1);
        }).to.not["throw"]();
        expect(function() {
          return expectTextNode(Node.create({
            text: true
          }), Node, true);
        }).to.not["throw"]();
        expect(function() {
          return expectTextNode(Node.create({
            text: function() {
              return '';
            }
          }), Node, '');
        }).to.not["throw"]();
        expect(function() {
          return expectTextNode(Node.create({
            text: function() {
              return 1;
            }
          }), Node, 1);
        }).to.not["throw"]();
        return expect(function() {
          return expectTextNode(Node.create({
            text: function() {
              return true;
            }
          }), Node, true);
        }).to.not["throw"]();
      });
    });
  });

  describe('new Node', function() {
    describe('init', function() {
      it("should return a valid text node, if cfg = 'text'", function() {
        return expectTextNode(new Node('text'), Node, 'text');
      });
      it("should return a valid text node, if cfg = Text", function() {
        return expectTextNode(new Node(getText('text')), Node, 'text');
      });
      it("should return a valid text node, if cfg.text = 'text'", function() {
        return expectTextNode(new Node({
          text: 'text'
        }), Node, 'text');
      });
      it("should return a valid text node, if cfg.tag = Text", function() {
        return expectTextNode(new Node({
          tag: getText('text')
        }), Node, 'text');
      });
      it("should return a valid tag node, if cfg = HTMLELement", function() {
        return expectTagNode(new Node(getTag('div')), Node, 'div');
      });
      it("should return a valid tag node, if cfg.tag = 'div'", function() {
        return expectTagNode(new Node({
          tag: 'div'
        }), Node, 'div');
      });
      return it("should return a valid tag node, if cfg.tag = HTMLELement", function() {
        return expectTagNode(new Node({
          tag: getTag('div')
        }), Node, 'div');
      });
    });
    describe('init error', function() {
      it("should throw an error, if cfg = null", function() {
        return expect(function() {
          return updateNow(new Node());
        }).to["throw"]();
      });
      it("should throw an error, if neither tag nor text are set", function() {
        return expect(function() {
          return updateNow(new Node({}));
        }).to["throw"]();
      });
      it("should throw an error, if cfg.tag is invalid", function() {
        expect(function() {
          return updateNow(new Node({
            tag: 1
          }));
        }).to["throw"]();
        expect(function() {
          return updateNow(new Node({
            tag: true
          }));
        }).to["throw"]();
        expect(function() {
          return updateNow(new Node({
            tag: {}
          }));
        }).to["throw"]();
        expect(function() {
          return updateNow(new Node({
            tag: []
          }));
        }).to["throw"]();
        expect(function() {
          return updateNow(new Node({
            tag: function() {}
          }));
        }).to["throw"]();
        return expect(function() {
          return updateNow(new Node({
            tag: Node
          }));
        }).to["throw"]();
      });
      it("should throw an error, if cfg.text is invalid", function() {
        expect(function() {
          return updateNow(new Node({
            text: null
          }));
        }).to["throw"]();
        expect(function() {
          return updateNow(new Node({
            text: {}
          }));
        }).to["throw"]();
        expect(function() {
          return updateNow(new Node({
            text: []
          }));
        }).to["throw"]();
        expect(function() {
          return updateNow(new Node({
            text: function() {}
          }));
        }).to["throw"]();
        expect(function() {
          return updateNow(new Node({
            text: function() {
              return {};
            }
          }));
        }).to["throw"]();
        return expect(function() {
          return updateNow(new Node({
            text: function() {
              return [];
            }
          }));
        }).to["throw"]();
      });
      return it("should not throw an error, if cfg.text is valid", function() {
        expect(function() {
          return expectTextNode(new Node({
            text: ''
          }), Node, '');
        }).to.not["throw"]();
        expect(function() {
          return expectTextNode(new Node({
            text: 1
          }), Node, 1);
        }).to.not["throw"]();
        expect(function() {
          return expectTextNode(new Node({
            text: true
          }), Node, true);
        }).to.not["throw"]();
        expect(function() {
          return expectTextNode(new Node({
            text: function() {
              return '';
            }
          }), Node, '');
        }).to.not["throw"]();
        expect(function() {
          return expectTextNode(new Node({
            text: function() {
              return 1;
            }
          }), Node, 1);
        }).to.not["throw"]();
        return expect(function() {
          return expectTextNode(new Node({
            text: function() {
              return true;
            }
          }), Node, true);
        }).to.not["throw"]();
      });
    });
    describe('with attr', function() {
      return it("should create a attr title = 'my title'", function() {
        var cfg, node;
        cfg = {
          tag: 'div',
          title: 'my title'
        };
        expectTagNode(node = new Node(cfg), Node, 'div');
        return expectAttr(node, 'title', 'my title');
      });
    });
    describe('with bool', function() {
      it("should create a bool attr disabled = true", function() {
        var cfg, node;
        cfg = {
          tag: 'div',
          disabled: true
        };
        expectTagNode(node = new Node(cfg), Node, 'div');
        return expectBoolAttr(node, 'disabled', true);
      });
      it("should create a bool attr disabled = false", function() {
        var cfg, node;
        cfg = {
          tag: 'div',
          disabled: false
        };
        expectTagNode(node = new Node(cfg), Node, 'div');
        return expectBoolAttr(node, 'disabled', false);
      });
      return it("should remove a bool attr disabled = undefined", function() {
        var cfg, node;
        cfg = {
          tag: 'div',
          disabled: void 0
        };
        expectTagNode(node = new Node(cfg), Node, 'div');
        return expectBoolAttr(node, 'disabled', void 0);
      });
    });
    describe('with tag children', function() {
      it("should add a child tag node if children = [tag: 'div']", function() {
        var cfg, node;
        cfg = {
          tag: 'div',
          children: [
            {
              tag: 'div'
            }
          ]
        };
        expectTagNode(node = new Node(cfg), Node, 'div');
        return expectTagNode(node.children[0], Node, 'div');
      });
      it("should add a child tag node with class MyExtendedNode if children = [{tag: 'div', clazz:MyExtendedNode}]", function() {
        var cfg, node;
        cfg = {
          tag: 'div',
          children: [
            {
              tag: 'div',
              clazz: MyExtendedNode
            }
          ]
        };
        expectTagNode(node = new Node(cfg), Node, 'div');
        return expectTagNode(node.children[0], MyExtendedNode, 'div');
      });
      it("should add a child tag node if children = [HTMLElement]", function() {
        var cfg, node;
        cfg = {
          tag: 'div',
          children: [getTag('div')]
        };
        expectTagNode(node = new Node(cfg), Node, 'div');
        return expectTagNode(node.children[0], Node, 'div');
      });
      it("should add a child tag node if children = [tag:HTMLElement]", function() {
        var cfg, node;
        cfg = {
          tag: 'div',
          children: [
            {
              tag: getTag('div')
            }
          ]
        };
        expectTagNode(node = new Node(cfg), Node, 'div');
        return expectTagNode(node.children[0], Node, 'div');
      });
      return it("should add a child tag node with class MyExtendedNode if children = [{tag: HTMLElement, clazz:MyExtendedNode}]", function() {
        var cfg, node;
        cfg = {
          tag: 'div',
          children: [
            {
              tag: getTag('div'),
              clazz: MyExtendedNode
            }
          ]
        };
        expectTagNode(node = new Node(cfg), Node, 'div');
        return expectTagNode(node.children[0], MyExtendedNode, 'div');
      });
    });
    describe('with tag child', function() {
      it("should add a child tag node if child = tag: 'div'", function() {
        var cfg, node;
        cfg = {
          tag: 'div',
          child: {
            tag: 'div'
          }
        };
        expectTagNode(node = new Node(cfg), Node, 'div');
        return expectTagNode(node.children[0], Node, 'div');
      });
      it("should add a child tag node if child = HTMLElement", function() {
        var cfg, node;
        cfg = {
          tag: 'div',
          child: getTag('div')
        };
        expectTagNode(node = new Node(cfg), Node, 'div');
        return expectTagNode(node.children[0], Node, 'div');
      });
      return it("should add a child tag node if child = tag: HTMLElement", function() {
        var cfg, node;
        cfg = {
          tag: 'div',
          child: {
            tag: getTag('div')
          }
        };
        expectTagNode(node = new Node(cfg), Node, 'div');
        return expectTagNode(node.children[0], Node, 'div');
      });
    });
    describe('with text children', function() {
      it("should add a child text node if children = 'my text'", function() {
        var cfg, node;
        cfg = {
          tag: 'div',
          children: 'my text'
        };
        expectTagNode(node = new Node(cfg), Node, 'div');
        return expectTextNode(node.children[0], Node, 'my text');
      });
      it("should add a child text node if children = ['my text']", function() {
        var cfg, node;
        cfg = {
          tag: 'div',
          children: ['my text']
        };
        expectTagNode(node = new Node(cfg), Node, 'div');
        return expectTextNode(node.children[0], Node, 'my text');
      });
      it("should add a child text node if children = [Text]", function() {
        var cfg, node;
        cfg = {
          tag: 'div',
          children: [getText('my text')]
        };
        expectTagNode(node = new Node(cfg), Node, 'div');
        return expectTextNode(node.children[0], Node, 'my text');
      });
      it("should add a child text node if children = [text:'my text']", function() {
        var cfg, node;
        cfg = {
          tag: 'div',
          children: [
            {
              text: 'my text'
            }
          ]
        };
        expectTagNode(node = new Node(cfg), Node, 'div');
        return expectTextNode(node.children[0], Node, 'my text');
      });
      it("should add a child text node with class MyExtendedNode if children = [{text:'my text', clazz:MyExtendedNode}]", function() {
        var cfg, node;
        cfg = {
          tag: 'div',
          children: [
            {
              text: 'my text',
              clazz: MyExtendedNode
            }
          ]
        };
        expectTagNode(node = new Node(cfg), Node, 'div');
        return expectTextNode(node.children[0], MyExtendedNode, 'my text');
      });
      return it("should add a child text node with class MyExtendedNode if children = [{tag:Text, clazz:MyExtendedNode}]", function() {
        var cfg, node;
        cfg = {
          tag: 'div',
          children: [
            {
              tag: getText('my text'),
              clazz: MyExtendedNode
            }
          ]
        };
        expectTagNode(node = new Node(cfg), Node, 'div');
        return expectTextNode(node.children[0], MyExtendedNode, 'my text');
      });
    });
    describe('with text', function() {
      it("should add a child text node if text = 'my text'", function() {
        var cfg, node;
        cfg = {
          tag: 'div',
          text: 'my text'
        };
        expectTagNode(node = new Node(cfg), Node, 'div');
        return expectTextNode(node.children[0], Node, 'my text');
      });
      return it("should add a child text node if text = Text", function() {
        var cfg, node;
        cfg = {
          tag: 'div',
          text: getText('my text')
        };
        expectTagNode(node = new Node(cfg), Node, 'div');
        return expectTextNode(node.children[0], Node, 'my text');
      });
    });
    return describe('with text child', function() {
      it("should add a child text node if child = 'my text'", function() {
        var cfg, node;
        cfg = {
          tag: 'div',
          child: 'my text'
        };
        expectTagNode(node = new Node(cfg), Node, 'div');
        return expectTextNode(node.children[0], Node, 'my text');
      });
      it("should add a child text node if child = text:'my text'", function() {
        var cfg, node;
        cfg = {
          tag: 'div',
          child: {
            text: 'my text'
          }
        };
        expectTagNode(node = new Node(cfg), Node, 'div');
        return expectTextNode(node.children[0], Node, 'my text');
      });
      it("should add a child text node if child = Text", function() {
        var cfg, node;
        cfg = {
          tag: 'div',
          child: getText('my text')
        };
        expectTagNode(node = new Node(cfg), Node, 'div');
        return expectTextNode(node.children[0], Node, 'my text');
      });
      return it("should add a child text node if child = tag: Text", function() {
        var cfg, node;
        cfg = {
          tag: 'div',
          child: {
            tag: getText('my text')
          }
        };
        expectTagNode(node = new Node(cfg), Node, 'div');
        return expectTextNode(node.children[0], Node, 'my text');
      });
    });
  });

  describe('node instance', function() {
    describe('appendTo', function() {
      it('should append the nodes view to the dom', function() {
        var node, parent;
        parent = getTag('div');
        node = new Node({
          tag: 'div'
        });
        node.appendTo(parent);
        expect(parent.childNodes[0]).to.equal(node.view);
        return expect(parent.childNodes.length).to.equal(1);
      });
      it('should throw an error if the dom is controlled by a node', function() {
        var node, parent;
        parent = new Node({
          tag: 'div'
        });
        node = new Node({
          tag: 'div'
        });
        return expect(function() {
          return node.appendTo(parent.view);
        }).to["throw"]();
      });
      return it('should not throw an error if Node.CHECK_DOM = false', function() {
        var node, parent;
        Node.CHECK_DOM = false;
        parent = new Node({
          tag: 'div'
        });
        node = new Node({
          tag: 'div'
        });
        expect(function() {
          return node.appendTo(parent.updateNow().view);
        }).to.not["throw"]();
        return Node.CHECK_DOM = true;
      });
    });
    describe('behind', function() {
      it('should append the nodes view behind the dom', function() {
        var node, parent, prev;
        parent = getTag('div');
        node = new Node({
          tag: 'div'
        });
        parent.appendChild(getTag('div'));
        parent.appendChild(prev = getTag('div'));
        parent.appendChild(getTag('div'));
        node.behind(prev);
        expect(parent.childNodes[2]).to.equal(node.view);
        return expect(parent.childNodes.length).to.equal(4);
      });
      it('should append the nodes view behind the dom if the dom is the last child', function() {
        var node, parent, prev;
        parent = getTag('div');
        node = new Node({
          tag: 'div'
        });
        parent.appendChild(getTag('div'));
        parent.appendChild(getTag('div'));
        parent.appendChild(prev = getTag('div'));
        node.behind(prev);
        expect(parent.childNodes[3]).to.equal(node.view);
        return expect(parent.childNodes.length).to.equal(4);
      });
      it('should throw an error if the doms parent is controlled by a node', function() {
        var node, parent, prev;
        parent = new Node({
          tag: 'div'
        });
        node = new Node({
          tag: 'div'
        });
        parent.updateNow().view.appendChild(prev = getTag('div'));
        return expect(function() {
          return node.behind(prev);
        }).to["throw"]();
      });
      return it('should not throw an error if Node.CHECK_DOM = false', function() {
        var node, parent, prev;
        Node.CHECK_DOM = false;
        parent = new Node({
          tag: 'div'
        });
        node = new Node({
          tag: 'div'
        });
        parent.updateNow().view.appendChild(prev = getTag('div'));
        expect(function() {
          return node.behind(prev);
        }).to.not["throw"]();
        return Node.CHECK_DOM = true;
      });
    });
    describe('before', function() {
      it('should prepand the nodes view before the dom', function() {
        var next, node, parent;
        parent = getTag('div');
        node = new Node({
          tag: 'div'
        });
        parent.appendChild(getTag('div'));
        parent.appendChild(next = getTag('div'));
        node.before(next);
        expect(parent.childNodes[1]).to.equal(node.view);
        return expect(parent.childNodes.length).to.equal(3);
      });
      it('should throw an error if the doms parent is controlled by a node', function() {
        var next, node, parent;
        parent = new Node({
          tag: 'div'
        });
        node = new Node({
          tag: 'div'
        });
        parent.updateNow().view.appendChild(next = getTag('div'));
        return expect(function() {
          return node.before(next);
        }).to["throw"]();
      });
      return it('should not throw an error if Node.CHECK_DOM = false', function() {
        var next, node, parent;
        Node.CHECK_DOM = false;
        parent = new Node({
          tag: 'div'
        });
        node = new Node({
          tag: 'div'
        });
        parent.updateNow().view.appendChild(next = getTag('div'));
        expect(function() {
          return node.before(next);
        }).to.not["throw"]();
        return Node.CHECK_DOM = true;
      });
    });
    return describe('replace', function() {
      it('should replace the dom with the nodes view', function() {
        var node, old, parent;
        parent = getTag('div');
        node = new Node({
          tag: 'div'
        });
        parent.appendChild(old = getTag('div'));
        node.replace(old);
        expect(parent.childNodes[0]).to.equal(node.view);
        return expect(parent.childNodes.length).to.equal(1);
      });
      it('should throw an error if the doms parent is controlled by a node', function() {
        var node, old, parent;
        parent = new Node({
          tag: 'div'
        });
        node = new Node({
          tag: 'div'
        });
        parent.updateNow().view.appendChild(old = getTag('div'));
        return expect(function() {
          return node.replace(old);
        }).to["throw"]();
      });
      it('should not throw an error for the doms parent if Node.CHECK_DOM = false', function() {
        var node, old, parent;
        Node.CHECK_DOM = false;
        parent = new Node({
          tag: 'div'
        });
        node = new Node({
          tag: 'div'
        });
        parent.updateNow().view.appendChild(old = getTag('div'));
        expect(function() {
          return node.replace(old);
        }).to.not["throw"]();
        return Node.CHECK_DOM = true;
      });
      it('should throw an error if the dom is controlled by a node', function() {
        var node, old, parent;
        parent = getTag('div');
        node = new Node({
          tag: 'div'
        });
        parent.appendChild(old = (new Node({
          tag: 'div'
        })).updateNow().view);
        return expect(function() {
          return node.replace(old);
        }).to["throw"]();
      });
      return it('should not throw an error for the dom if Node.CHECK_DOM = false', function() {
        var node, old, parent;
        Node.CHECK_DOM = false;
        parent = getTag('div');
        node = new Node({
          tag: 'div'
        });
        parent.appendChild(old = (new Node({
          tag: 'div'
        })).updateNow().view);
        expect(function() {
          return node.replace(old);
        }).to.not["throw"]();
        return Node.CHECK_DOM = true;
      });
    });
  });

}).call(this);

//# sourceMappingURL=view-tree.js.map
