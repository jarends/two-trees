(function(pack)
{
    var win = window,
        process = win.process || (win.process = {}),
        env     = process.env || (process.env = {}),
        cfg     = {
        index:      0,
        total:      1,
        startIndex: 0,
        type:       'register::0.23030519376580205_1500928187083',
        path:       '/Users/JOA/Projects/workspaces/my/two-trees/test/js/index.js',
        pack:       pack
    };
    env.NODE_ENV = env.NODE_ENV || 'development'
    var packer = // Generated by CoffeeScript 1.12.6
(function() {
  var Pack;

  Pack = (function() {
    function Pack() {}

    Pack.prototype.init = function(cfg) {
      this.cfg = cfg;
      this.mainIndex = this.cfg.startIndex;
      this.map = {};
      this.chunks = {};
      this.prepare();
      if (this.cfg.total === 1) {
        this.start();
      }
      return null;
    };

    Pack.prototype.prepare = function() {
      var pack;
      this.startTime = Date.now();
      this.registered = 1;
      pack = this.cfg.pack;
      this.getModule = (function(_this) {
        return function(index, chunk) {
          var m, r;
          if (chunk) {
            return _this.getChunk(index, chunk);
          }
          m = _this.map[index];
          if (m) {
            return m.exports;
          }
          m = _this.map[index] = {
            require: _this.getModule,
            exports: {}
          };
          r = pack[index];
          if (r) {
            r(m, m.exports, m.require);
            return m.exports;
          } else {
            console.log("Error requiring '" + index + "': module doesn't exist");
          }
          return null;
        };
      })(this);
      document.addEventListener(this.cfg.type, (function(_this) {
        return function(e) {
          return _this.handleEvent(e);
        };
      })(this));
      return null;
    };

    Pack.prototype.getChunk = function(index, chunk) {
      var chunks, loader, resolve, resolver, script;
      chunks = this.chunks[chunk];
      if (this.map[index]) {
        resolver = (function(_this) {
          return function(clazz) {
            return new Promise(function(r) {
              var m;
              m = _this.getModule(index);
              if (clazz) {
                r(m[clazz]);
              } else {
                r(m);
              }
              return null;
            });
          };
        })(this);
      } else {
        if (!chunks) {
          chunks = this.chunks[chunk] = [];
          script = document.createElement('script');
          script.src = chunk;
          document.body.appendChild(script);
        }
        loader = {};
        resolve = (function(_this) {
          return function() {
            var clazz, m;
            clazz = loader.clazz;
            m = _this.getModule(index);
            if (clazz) {
              return loader.r(m[clazz]);
            } else {
              return loader.r(m);
            }
          };
        })(this);
        loader.resolve = resolve;
        chunks.push(loader);
        resolver = function(clazz) {
          loader.clazz = clazz;
          return new Promise(function(r) {
            return loader.r = r;
          });
        };
      }
      return resolver;
    };

    Pack.prototype.start = function() {
      this.getModule(this.mainIndex);
      return null;
    };

    Pack.prototype.addPack = function(pack) {
      var key, value;
      for (key in pack) {
        value = pack[key];
        if (!this.cfg.pack[key]) {
          this.cfg.pack[key] = value;
        } else {
          console.log("Error adding module: module '" + key + "' already exists");
        }
      }
      return null;
    };

    Pack.prototype.handleEvent = function(e) {
      var chunk, chunks, detail, i, len, loader, pack;
      detail = e.detail;
      if (detail) {
        detail.registered = true;
        pack = detail.pack;
        if (pack) {
          null;
          this.addPack(pack);
        } else {
          console.log("Error adding pack: pack doesn't exists in details: ", detail);
        }
      } else {
        console.log("Error adding pack: detail doesn't exist in event: ", event);
      }
      chunk = detail.chunk;
      if (!chunk) {
        if (detail.index === 0) {
          this.mainIndex = detail.startIndex;
        }
        if (++this.registered === this.cfg.total) {
          this.start();
        }
      } else {
        chunks = this.chunks[chunk];
        if (chunks) {
          for (i = 0, len = chunks.length; i < len; i++) {
            loader = chunks[i];
            loader.resolve();
          }
        }
      }
      return null;
    };

    return Pack;

  })();

  return new Pack();

}).call(this);

    packer.init(cfg);
})({
// /Users/JOA/Projects/workspaces/my/two-trees/test/js/index.js
0: function(module, exports, require) {
module.id = 'js/index.js';
// Generated by CoffeeScript 1.12.6
(function() {
  require(1);

}).call(this);


},
// /Users/JOA/Projects/workspaces/my/two-trees/test/js/view-tree.js
1: function(module, exports, require) {
module.id = 'js/view-tree.js';
// Generated by CoffeeScript 1.12.6
(function() {
  var COMP_CFG_ERR, ExtendedMockNode, MockNode, Node, VIEW_CFG_ERR, ViewTree, WrongViewCfgNode, create, expectNode, expectTag, expectText, expectType,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  ViewTree = require(2);

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


},
// /Users/JOA/Projects/workspaces/my/two-trees/src/js/view-tree.js
2: function(module, exports, require) {
module.id = '../src/js/view-tree.js';
// Generated by CoffeeScript 1.12.6
(function() {
  var COMP_CFG_ERROR, Node, VIEW_CFG_ERROR, ViewTree, __id__, addChild, change, create, createNode, createView, dirty, dirtyMap, disposeNode, getCfgJson, isBool, isFunc, isHTML, isNot, isNumber, isObject, isSimple, isString, j, lastTime, len, map, nodeMap, normalizeEvent, normalizeName, rafTimeout, remove, removeChild, removeEvents, render, replaceChild, rootMap, tagMap, throwNodeCfgError, throwViewCfgError, unmap, update, updateAttr, updateBool, updateChildren, updateClass, updateEvent, updateNow, updateProperties, updateStyle, updateText, vendor, vendors,
    slice = [].slice;

  __id__ = 0;

  COMP_CFG_ERROR = 'Cfg for creating a node must either be a string or an object containing a tag property as not empty string or a node class.';

  VIEW_CFG_ERROR = 'Cfg for creating a view must either be a string or an object containing a tag property as not empty string';

  isBool = function(value) {
    return typeof value === 'boolean';
  };

  isNumber = function(value) {
    return typeof value === 'number';
  };

  isString = function(value) {
    return typeof value === 'string' || value === value + '';
  };

  isObject = function(value) {
    return typeof value === 'object';
  };

  isFunc = function(value) {
    return typeof value === 'function';
  };

  isHTML = function(value) {
    return value instanceof HTMLElement;
  };

  isNot = function(value) {
    return value === null || value === void 0;
  };

  isSimple = function(value) {
    var t;
    t = typeof value;
    return t === 'string' || t === 'number' || t === 'boolean' || value === value + '' || value === true || value === false || !isNaN(value);
  };

  normalizeName = function(name) {
    return name.replace(/[A-Z]/g, function(name) {
      return '-' + name.toLowerCase();
    });
  };

  normalizeEvent = function(type) {
    type = type.slice(2);
    return type.charAt(0).toLowerCase() + normalizeName(type.slice(1));
  };

  throwNodeCfgError = function(cfg) {
    throw new Error(COMP_CFG_ERROR + ' cfg = ' + getCfgJson(cfg));
  };

  throwViewCfgError = function(cfg) {
    throw new Error(VIEW_CFG_ERROR + ' cfg = ' + getCfgJson(cfg));
  };

  getCfgJson = function(cfg) {
    var c;
    try {
      c = JSON.stringify(cfg);
    } catch (error) {

    }
    return c + '';
  };


  /*
      if cfg is string || boolean || number
          node is a text node
  
      if cfg is object
          tag can be
              string
                  which is mapped to an component class
                  the node name
  
      cfg =
          tag:
          style:
          className:
          children:
          event handlers starting with 'on'
   */

  Node = (function() {
    function Node(cfg) {
      this.register(cfg);
    }

    Node.prototype.register = function(cfg1) {
      this.cfg = cfg1;
      this.keep = false;
      if (!this.__id__) {
        this.__id__ = ++__id__;
        nodeMap[this.__id__] = this;
      }
      return this.__id__;
    };

    Node.prototype.dispose = function() {
      return null;
    };

    Node.prototype.onMount = function() {
      return null;
    };

    Node.prototype.onUnmount = function() {
      return this.keep;
    };

    Node.prototype.needsUpdate = function() {
      return true;
    };

    Node.prototype.canUpdate = function() {
      return true;
    };

    Node.prototype.update = function() {
      return update(this);
    };

    Node.prototype.render = function() {
      return this.cfg;
    };

    Node.prototype.onAdded = function() {};

    Node.prototype.onRemoved = function() {};

    Node.prototype.add = function(child) {};

    Node.prototype.addAt = function(child, index) {};

    Node.prototype.remove = function(child) {};

    Node.prototype.removeAt = function(index) {};

    return Node;

  })();

  tagMap = {};

  rootMap = {};

  nodeMap = {};

  dirtyMap = {};

  dirty = false;

  rafTimeout = null;

  map = function(tag, clazz, overwrite) {
    if (overwrite == null) {
      overwrite = false;
    }
    if (isNot(tagMap[tag]) || overwrite) {
      tagMap[tag] = clazz;
    }
    return null;
  };

  unmap = function(tag) {
    delete tagMap[tag];
    return null;
  };

  create = function(cfg, root, inject) {
    var clazz, node, tag;
    if (root == null) {
      root = null;
    }
    if (inject == null) {
      inject = null;
    }
    if (isNot(cfg)) {
      throwNodeCfgError(cfg);
    }
    tag = cfg.tag;
    if (isSimple(cfg) || (!tag && isSimple(cfg.text))) {
      clazz = ViewTree.DEFAULT_CLASS;
    } else {
      if (isFunc(tag) && (tag.prototype instanceof Node || tag === Node)) {
        clazz = cfg.tag;
      } else {
        if (!isString(tag) || tag === '') {
          throwNodeCfgError(cfg);
        }
        clazz = tagMap[tag] || ViewTree.DEFAULT_CLASS;
      }
    }
    node = createNode(clazz, cfg, inject);
    createView(node, node.render());
    if (root !== null) {
      render(node, root);
    } else if (false) {
      if (isSimple(cfg)) {
        updateText(node, cfg);
      } else {
        updateProperties(node, cfg);
      }
      node.onMount();
    }
    return node;
  };

  createNode = function(clazz, cfg, inject) {
    var key, m, node, p, value;
    inject = cfg.__i__ || inject;
    if (!inject) {
      return new clazz(cfg);
    }
    p = clazz.prototype;
    m = {};
    for (key in inject) {
      value = inject[key];
      m[key] = p[key];
      p[key] = value;
    }
    node = new clazz(cfg);
    node.__i__ = inject;
    delete cfg.__i__;
    for (key in inject) {
      p[key] = m[key];
    }
    return node;
  };

  createView = function(node, cfg) {
    var tag;
    if (isNot(cfg)) {
      throwViewCfgError(cfg);
    }
    if (isSimple(cfg) || (!cfg.tag && isSimple(cfg.text))) {
      node.tag = void 0;
      node.text = (cfg.text || cfg) + '';
      node.view = document.createTextNode(node.text);
    } else {
      if (!isString(tag = cfg.tag) || tag === '') {
        throwViewCfgError(cfg);
      }
      node.tag = tag;
      node.view = document.createElement(tag);
    }
    return node.view;
  };

  render = function(node, root) {
    var cfg;
    cfg = node.render();
    if (!node.view) {
      createView(node, cfg);
    }
    root.appendChild(node.view);
    if (isSimple(cfg)) {
      updateText(node, cfg);
    } else {
      updateProperties(node, cfg);
    }
    node.onMount();
    return null;
  };

  remove = function(nodeOrRoot) {};

  update = function(node) {
    var id;
    id = node != null ? node.__id__ : void 0;
    if (!id) {
      throw new Error("DOM ERROR: can't update node. Node doesn't exist. cfg = " + getCfgJson((node != null ? node.cfg : void 0) || null));
    }
    if (!dirty) {
      window.cancelAnimationFrame(rafTimeout);
      rafTimeout = window.requestAnimationFrame(updateNow);
    }
    dirtyMap[id] = true;
    dirty = true;
    return null;
  };

  updateNow = function() {
    var cfg, id, j, len, n, node, nodes;
    window.cancelAnimationFrame(rafTimeout);
    dirty = false;
    nodes = [];
    for (id in dirtyMap) {
      if (n = nodeMap[id]) {
        nodes.push(n);
      }
    }
    nodes.sort(function(a, b) {
      return a.depth - b.depth;
    });
    for (j = 0, len = nodes.length; j < len; j++) {
      node = nodes[j];
      if (!node) {
        continue;
      }
      cfg = node.render();
      if (node.tag !== cfg.tag) {
        replaceChild(node, cfg);
      } else {
        updateProperties(node, cfg);
      }
    }
    return null;
  };

  updateText = function(node, cfg) {
    var text;
    text = (cfg.text || cfg) + '';
    if (node.text !== text) {
      node.cfg = cfg;
      node.text = text;
      node.view.nodeValue = text;
    }
    return null;
  };

  updateProperties = function(node, cfg) {
    var attr, attrs, name, propMap, value;
    if (cfg instanceof Node) {
      cfg = cfg.render();
    }
    attrs = node.attrs || (node.attrs = {});
    propMap = Object.assign({}, attrs, node.events, cfg);
    if (propMap.hasOwnProperty('className')) {
      updateClass(node, cfg.className);
    }
    if (propMap.hasOwnProperty('style')) {
      updateStyle(node, cfg.style);
    }
    if (propMap.hasOwnProperty('children')) {
      updateChildren(node, cfg.children);
    }
    delete propMap.tag;
    delete propMap.__i__;
    delete propMap.keep;
    delete propMap.text;
    delete propMap.children;
    delete propMap.style;
    delete propMap.className;
    for (name in propMap) {
      attr = attrs[name];
      value = cfg[name];
      if (isBool(attr) || isBool(value)) {
        updateBool(node, value, name);
      } else {
        if (/^on/.test(name)) {
          updateEvent(node, value, name);
        } else {
          updateAttr(node, value, name);
        }
      }
    }
    return null;
  };

  updateAttr = function(node, value, name) {
    if (node.attrs[name] === value) {
      return;
    }
    if (value !== null && value !== void 0) {
      node.view.setAttribute(name, value);
      node.view[name] = value;
      node.attrs[name] = value;
    } else {
      node.view.removeAttribute(name);
      delete node.view[name];
      delete node.attrs[name];
    }
    return null;
  };

  updateClass = function(node, value) {
    if (node.attrs.className === value) {
      return;
    }
    if (value) {
      node.view.className = value;
      node.attrs.className = value;
    } else {
      node.view.className = void 0;
      delete node.attrs.className;
    }
    return null;
  };

  updateStyle = function(node, style) {
    var attrs, changed, css, name, prop, propMap, sobj, value, view;
    view = node.view;
    attrs = node.attrs;
    sobj = attrs.style;
    if (isNot(style)) {
      view.style.cssText = null;
      delete attrs.style;
    } else if (isString(style)) {
      view.style.cssText = style;
      attrs.style = style;
    } else {
      css = '';
      sobj = isObject(sobj) ? sobj : {};
      changed = false;
      propMap = Object.assign({}, style, sobj);
      for (name in propMap) {
        value = style[name];
        if (value !== sobj[name]) {
          changed = true;
        }
        sobj[name] = value;
        if (isNot(value)) {
          delete sobj[name];
        } else {
          prop = normalizeName(name);
          css += prop + ': ' + value + '; ';
        }
      }
      if (changed) {
        if (css.length) {
          css = css.slice(0, -1);
          view.style.cssText = css;
          attrs.style = sobj;
        } else {
          view.style.cssText = null;
          delete attrs.style;
        }
      }
    }
    return null;
  };

  updateBool = function(node, value, name) {
    var view;
    if (node.attrs[name] === value) {
      return;
    }
    view = node.view;
    if (isNot(value)) {
      view.removeAttribute(name);
      delete node.attrs[name];
    } else {
      node.attrs[name] = value;
      if (value) {
        view.setAttribute(name, '');
        view[name] = true;
      } else {
        view.removeAttribute(name);
        view[name] = false;
      }
    }
    return null;
  };

  updateEvent = function(node, callback, name) {
    var events, listener, type, view;
    events = node.events || (node.events = {});
    view = node.view;
    type = normalizeEvent(name);
    listener = events[name];
    if (isString(callback)) {
      callback = node[name];
    }
    if (listener !== callback) {
      if (listener) {
        view.removeEventListener(type, listener);
        delete events[name];
      }
      if (callback) {
        view.addEventListener(type, callback);
        events[name] = callback;
      }
    }
    return null;
  };

  removeEvents = function(node) {
    var events, listener, name, type, view;
    events = node.events;
    if (!events) {
      return null;
    }
    view = node.view;
    for (name in events) {
      listener = events[name];
      type = normalizeEvent(name);
      if (listener) {
        view.removeEventListener(type, listener);
      }
      delete events[name];
    }
    node.events = null;
    return null;
  };

  updateChildren = function(node, cfgs) {
    var cfg, child, children, i, j, l, ref;
    children = node.children || (node.children = []);
    cfgs = isString(cfgs) ? [cfgs] : cfgs || [];
    l = children.length > cfgs.length ? children.length : cfgs.length;
    for (i = j = 0, ref = l; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
      child = children[i];
      cfg = cfgs[i];
      if (!child && !cfg) {
        throw new Error(("DOM ERROR: either child or cfg at index " + i + " must be defined. Got ") + child + ', ' + cfg);
      }
      if (!child) {
        addChild(node, cfg);
      } else if (!cfg) {
        removeChild(child);
      } else {
        change(child, cfg);
      }
    }
    children.length = cfgs.length;
    return null;
  };

  change = function(node, cfg) {
    var canUpdate, needsUpdate;
    canUpdate = node.canUpdate();
    needsUpdate = node.needsUpdate();
    if (node === cfg && needsUpdate) {
      if (canUpdate) {
        updateProperties(node, node.render());
      } else {
        replaceChild(node, node.render());
      }
    } else if (node.tag !== cfg.tag) {
      replaceChild(node, cfg);
    } else if (node.tag === void 0) {
      updateText(node, cfg);
    } else if (canUpdate && needsUpdate) {
      updateProperties(node, cfg);
    }
    return false;
  };

  addChild = function(node, cfg) {
    var child;
    if (cfg instanceof Node) {
      child = cfg;
      cfg = child.render();
    } else {
      child = create(cfg, null, cfg.__i__ || node.__i__);
    }
    if (!child.view) {
      child.view = createView(child, cfg);
    }
    node.children.push(child);
    node.view.appendChild(child.view);
    child.parent = node;
    if (isSimple(cfg) || (!cfg.tag && isSimple(cfg.text))) {
      updateText(child, cfg);
    } else {
      updateProperties(child, cfg);
    }
    child.onMount();
    return null;
  };

  removeChild = function(child) {
    var node, view;
    node = child.parent;
    view = child.view;
    disposeNode(child);
    node.view.removeChild(view);
    return null;
  };

  replaceChild = function(child, cfg) {
    var children, i, node, view;
    consol.log('ViewTree.replaceChild: ', child, cfg);
    node = child.parent;
    children = node.children;
    i = children.indexOf(child);
    view = child.view;
    disposeNode(child);
    if (cfg instanceof Node) {
      child = cfg;
      cfg = child.render();
    } else {
      child = create(cfg, null, cfg.__i__ || node.__i__);
    }
    if (!child.view) {
      child.view = createView(child, cfg);
    }
    children[i] = child;
    child.parent = node;
    node.view.replaceChild(child.view, view);
    if (isSimple(cfg) || (!cfg.tag && isSimple(cfg.text))) {
      updateText(child, cfg);
    } else {
      updateProperties(child, cfg);
    }
    child.onMount();
    return null;
  };

  disposeNode = function(node) {
    var child, j, len, ref;
    if (node.onUnmount() !== true) {
      console.log('dispose node now: ', node);
      removeEvents(node);
      if (node.children && node.children.length) {
        ref = node.children;
        for (j = 0, len = ref.length; j < len; j++) {
          child = ref[j];
          disposeNode(child);
        }
      }
      delete node.children;
      delete node.view;
      delete nodeMap[node.__id__];
    }
    node.parent = null;
    return null;
  };

  if (typeof window !== 'undefined') {
    lastTime = 0;
    vendors = ['webkit', 'moz'];
    for (j = 0, len = vendors.length; j < len; j++) {
      vendor = vendors[j];
      if (window.requestAnimationFrame) {
        break;
      }
      window.requestAnimationFrame = window[vendor + 'RequestAnimationFrame'];
      window.cancelAnimationFrame = window[vendor + 'CancelAnimationFrame'] || window[vendor + 'CancelRequestAnimationFrame'];
    }
    if (!window.requestAnimationFrame) {
      window.requestAnimationFrame = function(callback) {
        var currTime, id, rAF, timeToCall;
        currTime = Date.now();
        timeToCall = Math.max(0, 16 - currTime + lastTime);
        rAF = function() {
          return callback(currTime + timeToCall);
        };
        id = window.setTimeout(rAF, timeToCall);
        lastTime = currTime + timeToCall;
        return id;
      };
    }
    if (!window.cancelAnimationFrame) {
      window.cancelAnimationFrame = function(id) {
        clearTimeout(id);
        return null;
      };
    }
  }

  if (typeof Object.assign === 'undefined') {
    Object.assign = function() {
      var args, k, key, len1, src, target;
      target = arguments[0], args = 2 <= arguments.length ? slice.call(arguments, 1) : [];
      for (k = 0, len1 = args.length; k < len1; k++) {
        src = args[k];
        for (key in src) {
          target[key] = src[key];
        }
      }
      return target;
    };
  }

  ViewTree = {
    Node: Node,
    DEFAULT_CLASS: Node,
    HANDLE_CTX: true,
    HANDLE_DATA_TREE: true,
    COMP_CFG_ERROR: COMP_CFG_ERROR,
    VIEW_CFG_ERROR: VIEW_CFG_ERROR,
    map: map,
    unmap: unmap,
    create: create,
    render: render,
    remove: remove,
    update: update,
    updateNow: updateNow
  };

  if (typeof module !== 'undefined') {
    module.exports = ViewTree;
  }

  if (typeof window !== 'undefined') {
    window.ViewTree = ViewTree;
  } else {
    this.ViewTree = ViewTree;
  }

}).call(this);


}
});
//# sourceMappingURL=index.pack.js.map