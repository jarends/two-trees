(function(pack)
{
    var win = window,
        process = win.process || (win.process = {}),
        env     = process.env || (process.env = {}),
        cfg     = {
        index:      0,
        total:      1,
        startIndex: 0,
        type:       'register::0.8810525810578822_1500917226954',
        path:       '/Users/JOA/Projects/workspaces/my/two-trees/example/js/context.js',
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
// /Users/JOA/Projects/workspaces/my/two-trees/example/js/context.js
0: function(module, exports, require) {
module.id = 'js/context.js';
// Generated by CoffeeScript 1.12.6
(function() {
  var AppView, Context, DataTree, ViewTree;

  ViewTree = require(1);

  DataTree = require(2);

  AppView = require(3);

  Context = (function() {
    function Context() {
      var app, model;
      model = new DataTree({
        title: 'hello two-trees!',
        bgGreen: 255
      });
      app = new AppView({
        tag: AppView,
        model: model
      });
      ViewTree.render(app, document.querySelector('.app'));
    }

    return Context;

  })();

  module.exports = new Context();

}).call(this);


},
// /Users/JOA/Projects/workspaces/my/two-trees/src/js/view-tree.js
1: function(module, exports, require) {
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


},
// /Users/JOA/Projects/workspaces/my/two-trees/src/js/data-tree.js
2: function(module, exports, require) {
module.id = '../src/js/data-tree.js';
// Generated by CoffeeScript 1.12.6
(function() {
  var TreeTwo, __id__, addOwner, removeOwner;

  __id__ = 0;

  TreeTwo = (function() {
    function TreeTwo(root) {
      this.nodeMap = {};
      this.bindings = {};
      this.history = [];
      this.historyIndex = 0;
      if (root) {
        this.setRoot(root);
      }
    }

    TreeTwo.prototype.setRoot = function(obj) {
      this.rootNode = this.createNode(null, '/', obj);
      return this.root = obj;
    };

    TreeTwo.prototype.getRoot = function() {
      if (!this.rootNode) {
        return null;
      }
      return this.rootNode.value;
    };

    TreeTwo.prototype.has = function(obj) {
      return typeof obj === 'object' && this.nodeMap[obj.__node_id__] !== void 0;
    };

    TreeTwo.prototype.bind = function(obj, name, callback) {
      var error, node, paths;
      node = typeof obj === 'object' ? this.nodeMap[obj.__node_id__] : null;
      if (!node) {
        console.error(error = 'Error: object not part of this tree: ', obj);
        throw new Error(error);
      }
      paths = {};
      this.addPaths(node, name, null, (function(_this) {
        return function(path) {
          var callbacks;
          callbacks = _this.bindings[path] || (_this.bindings[path] = []);
          if (callbacks.indexOf(callback) === -1) {
            console.log('add binding: ', path);
            callbacks.push(callback);
            return paths[path] = callback;
          }
        };
      })(this));
      return paths;
    };

    TreeTwo.prototype.unbind = function(paths) {
      var callback, callbacks, index, path, total, unbound;
      unbound = total = 0;
      for (path in paths) {
        callback = paths[path];
        callbacks = this.bindings[path];
        ++total;
        if (callbacks) {
          index = callbacks.indexOf(callback);
          if (index > -1) {
            ++unbound;
            callbacks.splice(index, 1);
          }
          if (callbacks.length === 0) {
            delete this.bindings[path];
          }
        }
      }
      return unbound === total;
    };

    TreeTwo.prototype.update = function(obj, name) {
      var error, node;
      node = typeof obj === 'object' ? this.nodeMap[obj.__node_id__] : this.rootNode;
      if (!node) {
        console.error(error = 'Error: object not part of this tree: ', obj);
        throw new Error(error);
      }
      this.currentActions = [];
      this.currentPaths = {};
      this.updatedMap = {};
      if (name !== void 0) {
        this.updateProp(node, name);
      } else {
        this.updateNode(node);
      }
      if (this.currentActions.length) {
        if (this.historyIndex < this.history.length) {
          this.history.length = this.historyIndex;
        }
        this.history.push(this.currentActions);
        ++this.historyIndex;
        this.currentActions.paths = this.currentPaths;
        this.dispatchBindings(this.currentPaths);
      }
      return false;
    };

    TreeTwo.prototype.undo = function() {
      var action, actions, j, len;
      if (this.historyIndex > 0) {
        actions = this.history[--this.historyIndex];
        for (j = 0, len = actions.length; j < len; j++) {
          action = actions[j];
          action.undo();
        }
        this.dispatchBindings(actions.paths);
      } else {
        console.log('undo not possible!!! ', this.historyIndex);
      }
      return null;
    };

    TreeTwo.prototype.redo = function() {
      var action, actions, j, len;
      if (this.historyIndex < this.history.length) {
        actions = this.history[this.historyIndex++];
        for (j = 0, len = actions.length; j < len; j++) {
          action = actions[j];
          action.redo();
        }
        this.dispatchBindings(actions.paths);
      } else {
        console.log('redo not possible!!! ', this.historyIndex);
      }
      return null;
    };

    TreeTwo.prototype.dispatchBindings = function(paths) {
      var callback, callbacks, called, dispatched, j, k, len, len1, name, node, parts, path, pcallbacks, ppath, value;
      called = [];
      dispatched = false;
      for (path in paths) {
        node = paths[path];
        parts = path.split('/');
        name = parts.pop() || '';
        ppath = parts.join('/') + '/*';
        callbacks = this.bindings[path];
        pcallbacks = this.bindings[ppath];
        value = node.value;
        if (callbacks) {
          for (j = 0, len = callbacks.length; j < len; j++) {
            callback = callbacks[j];
            if (called.indexOf(callback) === -1) {
              callback(value[name], value, name, path);
              dispatched = true;
              called.push(callback);
            }
          }
        }
        if (pcallbacks) {
          for (k = 0, len1 = pcallbacks.length; k < len1; k++) {
            callback = pcallbacks[k];
            callback(value);
            dispatched = true;
          }
        }
      }
      return dispatched;
    };

    TreeTwo.prototype.createNode = function(owner, name, value) {
      var i, id, j, key, l, node, props, ref;
      if (value) {
        node = this.nodeMap[value.__node_id__];
      }
      if (!node) {
        id = ++__id__;
        node = {
          id: id,
          value: value,
          type: 'value',
          owners: {}
        };
        this.nodeMap[node.id] = node;
        if (owner) {
          this.addPaths(owner, name, this.currentPaths);
          addOwner(node, owner, name);
        }
        if (value) {
          if (value.constructor.name === 'Array') {
            Object.defineProperty(value, '__node_id__', {
              value: node.id,
              enumerable: false
            });
            node.type = 'array';
            node.props = props = [];
            l = value.length;
            for (i = j = 0, ref = l; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
              props[i] = this.createNode(node, i, value[i]);
            }
          } else if (value.constructor.name === 'Object') {
            Object.defineProperty(value, '__node_id__', {
              value: node.id,
              enumerable: false
            });
            node.type = 'object';
            node.props = props = {};
            for (key in value) {
              props[key] = this.createNode(node, key, value[key]);
            }
          }
        }
      }
      return node;
    };

    TreeTwo.prototype.updateNode = function(node) {
      var i, j, key, keys, l, pl, props, ref, value, vl;
      if (this.updatedMap[node.id]) {
        return true;
      }
      this.updatedMap[node.id] = true;
      value = node.value;
      props = node.props;
      if (node.type === 'array') {
        pl = props.length;
        vl = value.length;
        l = pl > vl ? pl : vl;
        for (i = j = 0, ref = l; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
          this.updateProp(node, i);
        }
        if (pl !== vl) {
          this.addChangeLengthAction(node, pl, vl);
          props.length = vl;
        }
      } else if (node.type === 'object') {
        keys = Object.assign({}, props, value);
        for (key in keys) {
          this.updateProp(node, key);
        }
      }
      return null;
    };

    TreeTwo.prototype.updateProp = function(node, name) {
      var child, next, type, value;
      child = node.props[name];
      value = node.value[name];
      if (!child && value === void 0) {
        console.error("Error: either old or new value must exist for property \"" + name + "\" of node: ", node);
        return false;
      }
      if (!child) {
        child = this.createNode(node, name, value);
        this.addCreateAction(child, node, name);
      } else if (value === void 0) {
        if (child.type !== 'value') {
          this.updateNode(child);
        }
        removeOwner(child, node, name);
        this.addRemoveAction(child, node, name);
      } else {
        if (child.value === value) {
          if (child.type !== 'value') {
            if (!this.updatedMap[child.id]) {
              this.updateNode(child);
            }
          } else {
            return false;
          }
        } else {
          type = 'value';
          if (value) {
            if (value.constructor.name === 'Array') {
              type = 'array';
            } else if (value.constructor.name === 'Object') {
              type = 'object';
            }
          }
          if (type !== 'value' || type !== child.type) {
            if (child.type !== 'value') {
              this.updateNode(child);
            }
            removeOwner(child, node, name);
            next = this.createNode(node, name, value);
            this.addSwapAction(child, node, name, next);
          } else {
            this.addChangeValueAction(child, node, name, value);
            child.value = value;
          }
        }
      }
      return null;
    };

    TreeTwo.prototype.addCreateAction = function(node, owner, name) {
      this.addPaths(owner, name, this.currentPaths);
      this.currentActions.push({
        type: 'create',
        undo: function() {
          return removeOwner(node, owner, name);
        },
        redo: function() {
          return addOwner(node, owner, name);
        }
      });
      return null;
    };

    TreeTwo.prototype.addRemoveAction = function(node, owner, name) {
      this.addPaths(owner, name, this.currentPaths);
      this.currentActions.push({
        type: 'remove',
        undo: function() {
          return addOwner(node, owner, name);
        },
        redo: function() {
          return removeOwner(node, owner, name);
        }
      });
      return null;
    };

    TreeTwo.prototype.addSwapAction = function(node, owner, name, next) {
      this.addPaths(owner, name, this.currentPaths);
      this.currentActions.push({
        type: 'swap',
        undo: function() {
          removeOwner(next, owner, name);
          return addOwner(node, owner, name);
        },
        redo: function() {
          removeOwner(node, owner, name);
          return addOwner(next, owner, name);
        }
      });
      return null;
    };

    TreeTwo.prototype.addChangeValueAction = function(node, owner, name, newValue) {
      this.addPaths(owner, name, this.currentPaths);
      this.currentActions.push({
        type: 'changeValue',
        oldValue: node.value,
        undo: function() {
          node.value = this.oldValue;
          return owner.value[name] = this.oldValue;
        },
        redo: function() {
          node.value = newValue;
          return owner.value[name] = newValue;
        }
      });
      return null;
    };

    TreeTwo.prototype.addChangeLengthAction = function(node, oldLength, newLength) {
      this.currentActions.push({
        type: 'changeLength',
        undo: function() {
          return node.value.length = node.props.length = oldLength;
        },
        redo: function() {
          return node.value.length = node.props.length = newLength;
        }
      });
      return null;
    };

    TreeTwo.prototype.addPaths = function(node, path, paths, callback, root) {
      var id, n, names, owner, ref;
      path = path === null || path === void 0 ? '' : path + '';
      if (path) {
        path = '/' + path;
      }
      paths = paths || {};
      root = root || node;
      if (node === this.rootNode) {
        paths[path] = root;
        if (callback) {
          callback(path);
        }
      } else {
        ref = node.owners;
        for (id in ref) {
          names = ref[id];
          owner = this.nodeMap[id];
          for (n in names) {
            this.addPaths(owner, n + path, paths, callback, root);
          }
        }
      }
      return paths;
    };

    return TreeTwo;

  })();

  addOwner = function(node, owner, name) {
    var names, owners;
    owners = node.owners;
    names = owners[owner.id] || (owners[owner.id] = {});
    if (names[name]) {
      return null;
    }
    names[name] = true;
    owner.props[name] = node;
    owner.value[name] = node.value;
    return null;
  };

  removeOwner = function(node, owner, name) {
    var names, owners;
    owners = node.owners;
    names = owners[owner.id];
    if (!names || !names[name]) {
      return null;
    }
    delete names[name];
    delete owner.props[name];
    delete owner.value[name];
    return null;
  };

  if (Object.defineProperty === void 0) {
    Object.defineProperty = function(obj, name, data) {
      return obj[name] = data.value;
    };
  }

  if (typeof module !== 'undefined') {
    module.exports = TreeTwo;
  }

  if (typeof window !== 'undefined') {
    window.TreeTwo = TreeTwo;
  } else {
    this.TreeTwo = TreeTwo;
  }

}).call(this);


},
// /Users/JOA/Projects/workspaces/my/two-trees/example/js/app-view.js
3: function(module, exports, require) {
module.id = 'js/app-view.js';
// Generated by CoffeeScript 1.12.6
(function() {
  var AppView, ViewTree,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  ViewTree = require(1);

  AppView = (function(superClass) {
    extend(AppView, superClass);

    function AppView(cfg) {
      this.redo = bind(this.redo, this);
      this.undo = bind(this.undo, this);
      this.onClick = bind(this.onClick, this);
      AppView.__super__.constructor.call(this, cfg);
      this.model = cfg.model;
      this.data = cfg.model.root;
      this.title = this.data.title;
      this.data.title = this.title + " click me!";
    }

    AppView.prototype.onClick = function() {
      this.data.bgGreen = (Math.random() * 100 + 155) >> 0;
      this.data.title = this.title + (" clicks: " + (this.model.historyIndex + 1));
      this.model.update();
      this.update();
      return null;
    };

    AppView.prototype.undo = function() {
      this.model.undo();
      return this.update();
    };

    AppView.prototype.redo = function() {
      this.model.redo();
      return this.update();
    };

    AppView.prototype.render = function() {
      return {
        tag: 'div',
        children: [
          {
            tag: 'h1',
            className: 'my-class',
            style: "background-color: rgb(0," + this.data.bgGreen + ",0);",
            onClick: this.onClick,
            children: [
              {
                tag: 'div',
                style: 'padding: 20px;',
                children: this.data.title
              }
            ]
          }, {
            tag: 'button',
            disabled: this.model.historyIndex < 1,
            onClick: this.undo,
            children: 'undo'
          }, {
            tag: 'button',
            disabled: this.model.historyIndex >= this.model.history.length,
            onClick: this.redo,
            children: 'redo'
          }
        ]
      };
    };

    return AppView;

  })(ViewTree.Node);

  module.exports = AppView;

}).call(this);


}
});
//# sourceMappingURL=context.pack.js.map