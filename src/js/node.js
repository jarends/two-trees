// Generated by CoffeeScript 1.12.6

/*

    cfg used:
        Node.create cfg
        node.init -> through node.render()
        node.updateNow cfg
        performUpdate -> through node.updateNow node.render()
        Node.updateChildren


    cfg as string || boolean || number
        node is a text node

    cfg as object
        tag can be
            string
                which is mapped to an component class
                the node name
            HTMLElement
            node class    -> render only
            node instance -> render only
            undefined/null if text is defined

    cfg as node instance # invalid in create

    cfg as HTMLElement -> in constructor only

    cfg as func -> has to return a valid node cfg


    cfg =
        tag:
        clazz:
        bind:
        inject:
        text:
        className:
        style:
        child:
        children:
        event handlers starting with 'on', camel case converts to kebab case


    update:

        if value == undefined -> no update
        if value == null      -> remove value
        else                  -> update
 */

(function() {
  var Node, __id__, addChild, addChildAt, append, before, behind, change, checkDom, classMap, clone, create, dirty, dirtyMap, disposeNode, domList, extendsNode, getKind, getOrCall, init, initTagFromDom, initTagNode, initTextFromDom, initTextNode, isBool, isDom, isDomText, isFunc, isNot, isNumber, isObject, isSimple, isString, j, lastTime, len, map, nodeMap, normalizeEvent, normalizeName, performUpdate, rafTimeout, remove, removeChild, removeChildAt, removeEvents, replace, replaceChild, unmap, update, updateAttr, updateBool, updateChildren, updateClass, updateEvent, updateNow, updateProps, updateStyle, updateText, vendor, vendors,
    slice = [].slice;

  getOrCall = function(value) {
    if (isFunc(value)) {
      return value();
    } else {
      return value;
    }
  };

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

  isDom = function(value) {
    return value instanceof HTMLElement;
  };

  isDomText = function(value) {
    return value instanceof Text;
  };

  isNot = function(value) {
    return value === null || value === void 0;
  };

  isSimple = function(value) {
    var t;
    return (t = typeof value) === 'string' || t === 'number' || t === 'boolean';
  };

  extendsNode = function(value) {
    return isFunc(value) && ((value.prototype instanceof Node) || value === Node);
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

  Node = (function() {
    Node.DEFAULT_CLASS = Node;

    Node.DEBUG = true;

    Node.CHECK_DOM = true;

    Node.TEXT_KIND = 0;

    Node.TAG_KIND = 1;

    function Node(cfg1) {
      this.cfg = cfg1;
      this.keep = false;
      this.valid = false;
      this.__id__ = ++__id__;
      nodeMap[this.__id__] = this;
      this.init();
    }

    Node.prototype.init = function() {
      return init(this);
    };

    Node.prototype.appendTo = function(dom) {
      return append(this, dom);
    };

    Node.prototype.behind = function(dom) {
      return behind(this, dom);
    };

    Node.prototype.before = function(dom) {
      return before(this, dom);
    };

    Node.prototype.replace = function(dom) {
      return replace(this, dom);
    };

    Node.prototype.remove = function() {
      return remove(this);
    };

    Node.prototype.addChild = function(child) {
      return addChild(this, child);
    };

    Node.prototype.addChildAt = function(child, index) {
      return addChildAt(this, child, index);
    };

    Node.prototype.removeChild = function(child) {
      return removeChild(this, child);
    };

    Node.prototype.removeChildAt = function(index) {
      return removeChildAt(this, index);
    };

    Node.prototype.updateNow = function() {
      return updateNow(this);
    };

    Node.prototype.update = function() {
      return update(this);
    };

    Node.prototype.render = function() {
      return this.cfg;
    };

    Node.prototype.dispose = function() {};

    Node.prototype.clone = function() {
      return clone(this);
    };

    Node.prototype.onAdded = function() {};

    Node.prototype.onRemoved = function() {};

    Node.prototype.onMount = function() {};

    Node.prototype.onUnmount = function() {
      return this.keep;
    };

    Node.prototype.onBeforeUpdate = function(cfg) {
      return true;
    };

    Node.prototype.onUpdated = function(cfg) {};

    return Node;

  })();

  __id__ = 0;

  classMap = {};

  domList = [];

  nodeMap = {};

  dirtyMap = {};

  dirty = false;

  rafTimeout = null;

  map = function(tag, clazz, overwrite) {
    if (overwrite == null) {
      overwrite = false;
    }
    if (classMap[tag] && !overwrite) {
      throw new Error("A class is already mapped for tag " + tag + ".");
    }
    return classMap[tag] = clazz;
  };

  unmap = function(tag) {
    return delete classMap[tag];
  };

  getKind = function(cfg) {
    var kind, tag;
    if (isNumber(kind = cfg.kind)) {
      return kind;
    }
    switch (true) {
      case isSimple(cfg):
        kind = Node.TEXT_KIND;
        break;
      case isDom(cfg):
        kind = Node.TAG_KIND;
        break;
      case isDomText(cfg):
        kind = Node.TEXT_KIND;
        break;
      default:
        tag = cfg.tag;
        switch (true) {
          case isNot(tag):
            kind = Node.TEXT_KIND;
            break;
          case isString(tag):
            kind = Node.TAG_KIND;
            break;
          case isDom(tag):
            kind = Node.TAG_KIND;
            break;
          case isDomText(tag):
            kind = Node.TEXT_KIND;
            break;
          default:
            if (extendsNode(tag)) {
              throw new Error("A tag must be a string or a HTMLElement, you specified a Node class.");
            }
            throw new Error("A tag must be a string or a HTMLElement.");
        }
    }
    return kind;
  };

  create = function(cfg) {
    var clazz, tag;
    if (isNot(cfg)) {
      throw new Error("A node can't be created from empty cfg.");
    }
    if (!extendsNode(clazz = cfg.clazz)) {
      if (!extendsNode(clazz = cfg.tag)) {
        clazz = null;
        if (isDom(cfg)) {
          tag = cfg.nodeName.toLowerCase();
        }
        if (isString(tag = tag || cfg.tag)) {
          clazz = classMap[tag];
        }
      }
    }
    clazz = clazz || Node.DEFAULT_CLASS;
    return new clazz(cfg);
  };

  init = function(node) {
    var cfg, tag;
    if (isNot(cfg = node.render())) {
      throw new Error("A node can't be initialized with empty cfg.");
    }
    switch (true) {
      case isSimple(cfg):
        initTextNode(node, node.cfg = {
          text: cfg + ''
        });
        break;
      case isDom(cfg):
        initTagFromDom(node, null, cfg);
        break;
      case isDomText(cfg):
        initTextFromDom(node, null, cfg);
        break;
      default:
        tag = cfg.tag;
        switch (true) {
          case isNot(tag):
            initTextNode(node, cfg);
            break;
          case isString(tag):
            initTagNode(node, cfg);
            break;
          case isDom(tag):
            initTagFromDom(node, cfg, tag);
            break;
          case isDomText(tag):
            initTextFromDom(node, cfg, tag);
            break;
          default:
            if (extendsNode(tag)) {
              throw new Error("A tag must be a string or a HTMLElement, you specified a Node class.");
            }
            throw new Error("A tag must be a string or a HTMLElement.");
        }
    }
    if (Node.CHECK_DOM) {
      domList.push(node.view);
    }
    return node;
  };

  initTextNode = function(node, cfg) {
    var text;
    text = cfg.text;
    if (isFunc(text)) {
      text = text();
    }
    if (!isSimple(text)) {
      throw new Error("The text for a text node must be a string, number or bool.");
    }
    node.text = text;
    node.tag = cfg.tag = null;
    node.kind = Node.TEXT_KIND;
    node.view = document.createTextNode(text);
    return node;
  };

  initTagNode = function(node, cfg) {
    var tag;
    node.tag = tag = cfg.tag;
    node.kind = Node.TAG_KIND;
    node.view = document.createElement(tag);
    updateProps(node, cfg);
    return node;
  };

  initTextFromDom = function(node, cfg, dom) {
    var text;
    if (Node.CHECK_DOM) {
      checkDom(dom);
    }
    node.text = dom.nodeValue;
    node.tag = null;
    node.kind = Node.TEXT_KIND;
    node.view = dom;
    if (cfg) {
      text = cfg.text;
      if (!isNot(text)) {
        if (isFunc(text)) {
          text = text();
        }
        if (!isSimple(text)) {
          throw new Error("The text for a text node must be a string, number or bool.");
        }
        node.text = dom.nodeValue = text;
      } else {
        cfg.text = node.text;
      }
    } else {
      cfg = node.cfg = {
        text: node.text
      };
    }
    cfg.tag = null;
    return node;
  };

  initTagFromDom = function(node, cfg, dom) {
    if (Node.CHECK_DOM) {
      checkDom(dom);
    }
    node.tag = dom.nodeName.toLowerCase();
    node.kind = Node.TAG_KIND;
    node.view = dom;
    cfg = cfg || (node.cfg = {});
    cfg.tag = node.tag;
    updateProps(node, cfg);
    return node;
  };

  checkDom = function(dom) {
    if (domList.indexOf(dom) > -1) {
      throw new Error('Dom element already controlled by another node.');
    }
  };

  performUpdate = function() {
    var id, j, len, n, node, nodes;
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
      if (!nodeMap[id = node.__id__] || !dirtyMap[id]) {
        continue;
      }
      node.updateNow();
    }
    dirtyMap = {};
    return null;
  };

  update = function(node) {
    var id;
    id = node.__id__;
    if (!id || nodeMap[id] !== node) {
      throw new Error("Can't update node. Node not part of this system.");
    }
    if (!dirty) {
      window.cancelAnimationFrame(rafTimeout);
      rafTimeout = window.requestAnimationFrame(performUpdate);
    }
    dirtyMap[id] = true;
    dirty = true;
    return null;
  };

  updateNow = function(node) {
    var cfg;
    cfg = node.render();
    if (node.kind !== getKind(cfg)) {
      replaceChild(node, cfg);
    } else if (node.kind === Node.TEXT_KIND) {
      updateText(node, cfg);
    } else if (node.kind === Node.TAG_KIND) {
      updateProps(node, cfg);
    } else {
      throw new Error('Unknown node kind. Got: ', node.kind);
    }
    return node;
  };

  updateText = function(node, cfg) {
    var text;
    delete dirtyMap[node.__id__];
    text = cfg.text;
    if (!isNot(text)) {
      if (isFunc(text)) {
        text = text();
      }
      if (!isSimple(text)) {
        throw new Error("The text for a text node must be a string, number or bool.");
      }
    }
    return node.view.nodeValue = text;
  };

  updateProps = function(node, cfg) {
    var attr, attrs, child, name, propMap, text, value;
    delete dirtyMap[node.__id__];
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
    if (propMap.hasOwnProperty('text')) {
      if (isFunc(text = cfg.text)) {
        text = text();
      }
      if (isSimple(text)) {
        updateChildren(node, text);
      } else if (isDomText(text)) {
        updateChildren(node, [text]);
      }
      if (Node.DEBUG) {
        if (cfg.hasOwnProperty('child')) {
          console.warn('child specified while text exists: ', cfg);
        }
        if (cfg.hasOwnProperty('children')) {
          console.warn('children specified while text exists', cfg);
        }
      }
    } else if (propMap.hasOwnProperty('child')) {
      if (isFunc(child = cfg.child)) {
        child = child();
      }
      updateChildren(node, [child]);
      if (Node.DEBUG) {
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
    delete propMap.className;
    delete propMap.style;
    delete propMap.children;
    delete propMap.bindings;
    for (name in propMap) {
      attr = attrs[name];
      value = cfg[name];
      if (isBool(value) || (isNot(value) && isBool(attr))) {
        updateBool(node, value, name);
      } else {
        if (/^on/.test(name)) {
          updateEvent(node, value, name);
        } else {
          if (isFunc(value)) {
            value = value();
          }
          if (isBool(value)) {
            updateBool(node, value, name);
          } else {
            updateAttr(node, value, name);
          }
        }
      }
    }
    return node;
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
    if (isNot(value)) {
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
    if (isFunc(value)) {
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
    if (isFunc(style)) {
      style = style();
    }
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
    if (isFunc(cfgs)) {
      cfgs = cfgs();
    }
    cfgs = isString(cfgs) ? [cfgs] : cfgs || [];
    l = children.length > cfgs.length ? children.length : cfgs.length;
    for (i = j = 0, ref = l; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
      child = children[i];
      cfg = cfgs[i];
      if (isFunc(cfg)) {
        cfg = cfg();
      }
      if (!child && !cfg) {
        throw new Error("Either child or cfg at index " + i + " must be defined.");
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
    var needsUpdate;
    needsUpdate = node.needsUpdate();
    if (node === cfg || node.constructor === cfg.tag) {
      if (needsUpdate && canUpdate) {
        updateProperties(node, node.render());
      }
      if (needsUpdate && !canUpdate) {
        replaceChild(node, node.render());
      }
    } else if (node.tag !== cfg.tag || cfg instanceof Node) {
      replaceChild(node, cfg);
    } else if (node.tag === void 0) {
      updateText(node, cfg);
    } else if (needsUpdate && canUpdate) {
      updateProperties(node, cfg);
    }
    return false;
  };

  addChild = function(node, cfg) {
    var child;
    if (cfg instanceof Node) {
      child = cfg;
    } else {
      child = create(cfg);
    }
    node.children.push(child);
    node.view.appendChild(child.view);
    child.parent = node;
    child.depth = node.depth + 1;
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
    cfg = child.render();
    if (!child.view) {
      child.view = createView(child, cfg);
    }
    children[i] = child;
    child.parent = node;
    child.depth = node.depth + 1;
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

  append = function(node, dom) {
    if (Node.CHECK_DOM) {
      checkDom(dom);
    }
    return dom.appendChild(node.view);
  };

  behind = function(node, dom) {
    var next, parent;
    parent = dom.parentNode;
    next = dom.nextSibling;
    if (Node.CHECK_DOM) {
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
    if (Node.CHECK_DOM) {
      checkDom(parent);
    }
    return parent.insertBefore(node.view, dom);
  };

  replace = function(node, dom) {
    var parent;
    parent = dom.parentNode;
    if (Node.CHECK_DOM) {
      checkDom(parent);
      checkDom(dom);
    }
    return parent.replaceChild(node.view, dom);
  };

  remove = function(node) {
    var parent;
    parent = node.view.parentNode;
    if (Node.CHECK_DOM) {
      checkDom(parent);
    }
    return parent.removeChild(node.view);
  };

  addChildAt = function(node, child, index) {};

  removeChildAt = function(node, index) {};

  disposeNode = function() {};

  clone = function() {};

  Node.create = create;

  Node.map = map;

  Node.unmap = unmap;

  Node.append = append;

  Node.behind = behind;

  Node.before = before;

  Node.replace = replace;

  Node.remove = remove;

  Node.getKind = getKind;

  Node.getOrCall = getOrCall;

  Node.isBool = isBool;

  Node.isNumber = isNumber;

  Node.isString = isString;

  Node.isObject = isObject;

  Node.isFunc = isFunc;

  Node.isDom = isDom;

  Node.isDomText = isDomText;

  Node.isNot = isNot;

  Node.isSimple = isSimple;

  Node.extendsNode = extendsNode;

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

  if (typeof module !== 'undefined') {
    module.exports = Node;
  }

  if (typeof window !== 'undefined') {
    window.Node = Node;
  } else {
    this.Node = Node;
  }

}).call(this);

//# sourceMappingURL=node.js.map