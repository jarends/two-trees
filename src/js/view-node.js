// Generated by CoffeeScript 1.12.6
(function() {
  var ViewNode, _, __id__, addChild, addChildAt, addChildNode, appendTo, before, behind, change, checkDom, classMap, cleanMap, create, createTagFromDom, createTagView, createTextFromDom, createTextView, createView, dirty, dirtyMap, disposeNode, domList, injectNode, j, lastTime, len, map, nodeMap, performUpdate, rafTimeout, register, remove, removeChild, removeChildAt, removeChildNode, removeEvents, replace, replaceChildNode, unmap, update, updateAttr, updateBool, updateChildren, updateClass, updateEvent, updateNow, updateProperties, updateStyle, updateText, vendor, vendors,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    slice = [].slice;

  _ = require('.//utils');

  __id__ = 0;

  ViewNode = (function() {
    ViewNode.DEBUG = true;

    ViewNode.CHECK_DOM = true;

    ViewNode.DEFAULT_CLASS = ViewNode;

    ViewNode.create = create;

    ViewNode.map = map;

    ViewNode.unmap = unmap;

    function ViewNode(cfg) {
      this.update = bind(this.update, this);
      this.register(cfg);
      this.updateCfg(cfg);
      this.updateNow();
    }

    ViewNode.prototype.register = function(cfg) {
      return register(this, cfg);
    };

    ViewNode.prototype.updateNow = function(cfg) {
      return updateNow(this, cfg);
    };

    ViewNode.prototype.createView = function(cfg) {
      return createView(this, cfg);
    };

    ViewNode.prototype.appendTo = function(dom) {
      return appendTo(this, dom);
    };

    ViewNode.prototype.behind = function(dom) {
      return behind(this, dom);
    };

    ViewNode.prototype.before = function(dom) {
      return before(this, dom);
    };

    ViewNode.prototype.replace = function(dom) {
      return replace(this, dom);
    };

    ViewNode.prototype.remove = function(dom) {
      return remove(this, dom);
    };

    ViewNode.prototype.addChild = function(child) {
      return addChild(this, child);
    };

    ViewNode.prototype.addChildAt = function(child, index) {
      return addChildAt(this, child, index);
    };

    ViewNode.prototype.removeChild = function(child) {
      return removeChild(this, child);
    };

    ViewNode.prototype.removeChildAt = function(index) {
      return removeChildAt(this, index);
    };

    ViewNode.prototype.updateCfg = function(cfg) {
      return (this.cfg = cfg) || true;
    };

    ViewNode.prototype.update = function() {
      return update(this);
    };

    ViewNode.prototype.render = function() {
      return this.cfg;
    };

    ViewNode.prototype.dispose = function() {};

    ViewNode.prototype.onMount = function() {};

    ViewNode.prototype.onUnmount = function() {
      return this.keep;
    };

    ViewNode.prototype.onAdded = function() {};

    ViewNode.prototype.onRemoved = function() {};

    return ViewNode;

  })();

  classMap = {};

  nodeMap = {};

  dirtyMap = {};

  cleanMap = {};

  domList = [];

  dirty = false;

  rafTimeout = null;

  create = function(cfg, root) {
    var clazz, tag;
    if (root == null) {
      root = null;
    }
    if (_.isNot(cfg)) {
      throw new Error("A node can't be created from empty cfg.");
    }
    if (!_.extendsNode(clazz = cfg.clazz)) {
      if (!_.extendsNode(clazz = cfg.tag)) {
        clazz = null;
        if (_.isDom(cfg)) {
          tag = cfg.nodeName.toLowerCase();
        }
        if (_.isString(tag = tag || cfg.tag)) {
          clazz = classMap[tag];
        }
      }
    }
    clazz = clazz || ViewNode.DEFAULT_CLASS;
    return new clazz(cfg);
  };

  register = function(node, cfg) {
    node.parent = null;
    node.depth = 0;
    node.keep = false;
    if (!node.__id__) {
      node.__id__ = ++__id__;
      nodeMap[node.__id__] = node;
    }
    node.__id__;
    return injectNode(node, cfg);
  };

  injectNode = function(node, cfg) {
    var inject, key, value;
    if (_.isNot(node.__i__) && cfg && cfg.__i__) {
      inject = node.__i__ = cfg.__i__;
      for (key in inject) {
        value = inject[key];
        node[key] = value;
      }
    }
    return node;
  };

  createView = function(node, cfg) {
    var tag;
    if (node.view) {
      throw new Error("View already exists");
    }
    if (_.isNot(cfg = node.render())) {
      throw new Error("A view for an empty cfg can't be created.");
    }
    switch (true) {
      case _.isSimple(cfg):
        createTextView(node, node.cfg = {
          text: cfg + ''
        });
        break;
      case _.isDom(cfg):
        createTagFromDom(node, null, cfg);
        break;
      case _.isDomText(cfg):
        createTextFromDom(node, null, cfg);
        break;
      default:
        tag = cfg.tag;
        switch (true) {
          case _.isNot(tag):
            createTextView(node, cfg);
            break;
          case _.isString(tag):
            createTagView(node, cfg);
            break;
          case _.isDom(tag):
            createTagFromDom(node, cfg, tag);
            break;
          case _.isDomText(tag):
            createTextFromDom(node, cfg, tag);
            break;
          default:
            if (_.extendsNode(tag)) {
              throw new Error("A tag must be a string or a HTMLElement, you specified a ViewNode class.");
            }
            throw new Error("A tag must be a string or a HTMLElement.");
        }
    }
    if (ViewNode.CHECK_DOM) {
      domList.push(node.view);
    }
    return node;
  };

  createTextView = function(node, cfg) {
    var text;
    text = cfg.text;
    if (_.isFunc(text)) {
      text = text();
    }
    if (!_.isSimple(text)) {
      throw new Error("The text for a text node must be a string, number or bool.");
    }
    node.text = text;
    node.tag = cfg.tag = void 0;
    node.kind = ViewNode.TEXT_KIND;
    return node.view = document.createTextNode(text);
  };

  createTextFromDom = function(node, cfg, dom) {
    var text;
    if (ViewNode.CHECK_DOM) {
      checkDom(dom);
    }
    node.text = dom.nodeValue;
    node.tag = null;
    node.kind = ViewNode.TEXT_KIND;
    node.view = dom;
    if (cfg) {
      text = cfg.text;
      if (_.isNot(text)) {
        cfg.text = node.text;
      } else {
        if (_.isFunc(text)) {
          text = text();
        }
        if (!_.isSimple(text)) {
          throw new Error("The text for a text node must be a string, number or bool.");
        }
        node.text = dom.nodeValue = text;
      }
    } else {
      cfg = node.cfg = {
        text: node.text
      };
    }
    cfg.tag = void 0;
    return node;
  };

  createTagView = function(node, cfg) {
    var tag;
    node.tag = tag = cfg.tag;
    node.kind = ViewNode.TAG_KIND;
    node.view = document.createElement(tag);
    return node;
  };

  createTagFromDom = function(node, cfg, dom) {
    if (ViewNode.CHECK_DOM) {
      checkDom(dom);
    }
    node.tag = dom.nodeName.toLowerCase();
    node.kind = ViewNode.TAG_KIND;
    node.view = dom;
    cfg = cfg || (node.cfg = {});
    cfg.tag = node.tag;
    return node;
  };

  updateNow = function(node, cfg) {
    cfg = cfg || node.render();
    if (_.isNot(node.view)) {
      node.createView(cfg);
    }
    if (_.isSimple(cfg) || (!cfg.tag && (_.isSimple(cfg.text) || _.isFunc(cfg.text)))) {
      updateText(node, cfg);
    } else {
      updateProperties(node, cfg);
    }
    return node;
  };

  update = function(node) {
    var id;
    id = node != null ? node.__id__ : void 0;
    if (!id) {
      throw new Error("Can't update node. ViewNode doesn't exist.");
    }
    if (!dirty) {
      window.cancelAnimationFrame(rafTimeout);
      rafTimeout = window.requestAnimationFrame(performUpdate);
    }
    dirtyMap[id] = true;
    dirty = true;
    return null;
  };

  performUpdate = function() {
    var cfg, id, j, len, n, node, nodes;
    window.cancelAnimationFrame(rafTimeout);
    dirty = false;
    cleanMap = {};
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
      if (!node.view || !nodeMap[node.__id__] || cleanMap[node.__id__]) {
        continue;
      }
      cfg = node.render();
      if (_.isNot(node.tag) && _.isNot(cfg.tag)) {
        updateText(node, cfg);
      } else if (!(node.tag === cfg.tag || node.constructor === cfg.tag)) {
        replaceChildNode(node, cfg);
      } else {
        updateProperties(node, cfg);
      }
    }
    dirtyMap = {};
    return null;
  };

  updateText = function(node, cfg) {
    var text;
    cleanMap[node.__id__] = true;
    text = _.isFunc(cfg.text) ? cfg.text() : _.isString(cfg) ? cfg : cfg.text;
    if (node.text !== text) {
      node.cfg = cfg;
      node.text = text;
      node.view.nodeValue = text;
    }
    return null;
  };

  updateProperties = function(node, cfg) {
    var attr, attrs, child, name, propMap, text, value;
    cleanMap[node.__id__] = true;
    if (cfg instanceof ViewNode) {
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
    if (propMap.hasOwnProperty('text')) {
      if (_.isFunc(text = cfg.text)) {
        text = text();
      }
      if (_.isSimple(text)) {
        updateChildren(node, [text]);
      } else if (_.isDomText(text)) {
        updateChildren(node, [text]);
      }
      if (ViewNode.DEBUG) {
        if (cfg.hasOwnProperty('child')) {
          console.warn('child specified while text exists: ', cfg);
        }
        if (cfg.hasOwnProperty('children')) {
          console.warn('children specified while text exists', cfg);
        }
      }
    } else if (propMap.hasOwnProperty('child')) {
      if (_.isFunc(child = cfg.child)) {
        child = child();
      }
      updateChildren(node, [child]);
      if (ViewNode.DEBUG) {
        if (cfg.hasOwnProperty('children')) {
          console.warn('children specified while text exists', cfg);
        }
      }
    } else if (propMap.hasOwnProperty('children')) {
      updateChildren(node, cfg.children);
    }
    delete propMap.tag;
    delete propMap.clazz;
    delete propMap.__i__;
    delete propMap.keep;
    delete propMap.text;
    delete propMap.child;
    delete propMap.className;
    delete propMap.style;
    delete propMap.children;
    delete propMap.bindings;
    for (name in propMap) {
      attr = attrs[name];
      value = cfg[name];
      if (_.isBool(value) || (_.isNot(value) && _.isBool(attr))) {
        updateBool(node, value, name);
      } else {
        if (/^on/.test(name)) {
          updateEvent(node, value, name);
        } else {
          if (_.isFunc(value)) {
            value = value();
          }
          if (_.isBool(value)) {
            updateBool(node, value, name);
          } else {
            updateAttr(node, value, name);
          }
        }
      }
    }
    return null;
  };

  updateAttr = function(node, value, name) {
    var view;
    node.attrs[name] = node.view.getAttribute(name);
    if (node.attrs[name] === value) {
      return;
    }
    view = node.view;
    if (value !== null && value !== void 0) {
      view.setAttribute(name, value);
      view[name] = value;
      node.attrs[name] = value;
    } else {
      view.removeAttribute(name);
      delete view[name];
      delete node.attrs[name];
    }
    return null;
  };

  updateBool = function(node, value, name) {
    var view;
    node.attrs[name] = node.view[name];
    if (node.attrs[name] === value) {
      return;
    }
    view = node.view;
    if (_.isNot(value)) {
      view.removeAttribute(name);
      view[name] = false;
      delete node.attrs[name];
    } else if (value === false) {
      view.removeAttribute(name);
      view[name] = false;
      node.attrs[name] = false;
    } else {
      view.setAttribute(name, '');
      view[name] = true;
      node.attrs[name] = true;
    }
    return null;
  };

  updateClass = function(node, value) {
    if (_.isFunc(value)) {
      value = value();
    }
    node.attrs.className = node.view.className;
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
    if (!view) {
      return;
    }
    if (_.isFunc(style)) {
      style = style();
    }
    if (_.isNot(style)) {
      view.style.cssText = null;
      delete attrs.style;
    } else if (_.isString(style)) {
      view.style.cssText = style;
      attrs.style = style;
    } else {
      css = '';
      sobj = _.isObject(sobj) ? sobj : {};
      changed = false;
      propMap = Object.assign({}, style, sobj);
      for (name in propMap) {
        value = style[name];
        if (value !== sobj[name]) {
          changed = true;
        }
        sobj[name] = value;
        if (_.isNot(value)) {
          delete sobj[name];
        } else {
          prop = _.normalizeName(name);
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

  updateEvent = function(node, callback, name) {
    var events, listener, type, view;
    events = node.events || (node.events = {});
    view = node.view;
    type = _.normalizeEvent(name);
    listener = events[name];
    if (_.isString(callback)) {
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
      type = _.normalizeEvent(name);
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
    if (_.isFunc(cfgs)) {
      cfgs = cfgs();
    }
    cfgs = _.isString(cfgs) ? [cfgs] : cfgs || [];
    l = children.length > cfgs.length ? children.length : cfgs.length;
    for (i = j = 0, ref = l; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
      child = children[i];
      cfg = cfgs[i];
      if (_.isFunc(cfg)) {
        cfg = cfg();
      }
      if (!child && !cfg) {
        throw new Error(("DOM ERROR: either child or cfg at index " + i + " must be defined. Got ") + child + ', ' + cfg);
      }
      if (!child) {
        addChildNode(node, cfg);
      } else if (!cfg) {
        removeChildNode(child);
      } else {
        change(child, cfg);
      }
    }
    children.length = cfgs.length;
    return null;
  };

  change = function(node, cfg) {
    var needsUpdate;
    needsUpdate = node.updateCfg(cfg);
    if (node === cfg || node.constructor === cfg.tag) {
      if (needsUpdate) {
        updateProperties(node, node.render());
      }
    } else if (node.tag !== cfg.tag && (node.tag || cfg.tag) || cfg instanceof ViewNode) {
      replaceChildNode(node, cfg);
    } else if (_.isNot(node.tag)) {
      updateText(node, cfg);
    } else if (needsUpdate) {
      updateProperties(node, cfg);
    }
    return false;
  };

  addChildNode = function(node, cfg) {
    var child;
    if (cfg instanceof ViewNode) {
      child = cfg;
    } else {
      if (!cfg.__i__) {
        cfg.__i__ = node.__i__;
      }
      child = create(cfg);
    }
    node.children.push(child);
    node.view.appendChild(child.view);
    child.parent = node;
    child.depth = node.depth + 1;
    child.onMount();
    return null;
  };

  removeChildNode = function(child) {
    var node, view;
    node = child.parent;
    view = child.view;
    disposeNode(child);
    node.view.removeChild(view);
    return null;
  };

  replaceChildNode = function(child, cfg) {
    var children, i, node, view;
    node = child.parent;
    children = node.children;
    i = children.indexOf(child);
    view = child.view;
    disposeNode(child);
    if (cfg instanceof ViewNode) {
      child = cfg;
      cfg = child.render();
    } else {
      if (!cfg.__i__) {
        cfg.__i__ = node.__i__;
      }
      child = create(cfg);
    }
    children[i] = child;
    child.parent = node;
    child.depth = node.depth + 1;
    node.view.replaceChild(child.view, view);
    if (_.isSimple(cfg) || (!cfg.tag && (_.isSimple(cfg.text) || _.isFunc(cfg.text)))) {
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
    node.depth = void 0;
    return null;
  };

  checkDom = function(dom) {
    if (domList.indexOf(dom) > -1) {
      throw new Error('Dom element already controlled by another node.');
    }
  };

  appendTo = function(node, dom) {
    if (ViewNode.CHECK_DOM) {
      checkDom(dom);
    }
    return dom.appendChild(node.view);
  };

  behind = function(node, dom) {
    var next, parent;
    parent = dom.parentNode;
    next = dom.nextSibling;
    if (ViewNode.CHECK_DOM) {
      checkDom(parent);
    }
    if (next) {
      return parent.insertBefore(node.view, next);
    } else {
      return parent.appendChild(node.view);
    }
  };

  before = function(node, dom) {
    var parent;
    parent = dom.parentNode;
    if (ViewNode.CHECK_DOM) {
      checkDom(parent);
    }
    return parent.insertBefore(node.view, dom);
  };

  replace = function(node, dom) {
    var parent;
    parent = dom.parentNode;
    if (ViewNode.CHECK_DOM) {
      checkDom(parent);
      checkDom(dom);
    }
    return parent.replaceChild(node.view, dom);
  };

  remove = function(node) {
    var parent;
    parent = node.view.parentNode;
    if (ViewNode.CHECK_DOM) {
      checkDom(parent);
    }
    return parent.removeChild(node.view);
  };

  addChild = function(node, child) {};

  addChildAt = function(node, child, index) {};

  removeChild = function(node, child) {};

  removeChildAt = function(node, index) {};

  map = function(tag, clazz, overwrite) {
    if (overwrite == null) {
      overwrite = false;
    }
    if (_.isNot(classMap[tag]) || overwrite) {
      classMap[tag] = clazz;
    }
    return null;
  };

  unmap = function(tag) {
    delete classMap[tag];
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

  ViewNode.create = create;

  ViewNode.map = map;

  ViewNode.unmap = unmap;

  if (typeof module !== 'undefined') {
    module.exports = ViewNode;
  }

  if (typeof window !== 'undefined') {
    window.ViewNode = ViewNode;
  } else {
    this.ViewNode = ViewNode;
  }

}).call(this);

//# sourceMappingURL=view-node.js.map
