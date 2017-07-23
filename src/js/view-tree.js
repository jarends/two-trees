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
      console.log('ctx: ', this.ctx);
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
    propMap = Object.assign({}, node.attrs, node.events, cfg);
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
    if (attrs.className || cfg.className) {
      updateClass(node, value);
    }
    if (attrs.style || cfg.style) {
      updateStyle(node, cfg.style);
    }
    if (attrs.children || cfg.children) {
      updateChildren(node, cfg.children);
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
      node.view.setAttribute('class', value);
      node.attrs.className = value;
    } else {
      node.view.removeAttribute('class');
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

//# sourceMappingURL=view-tree.js.map
