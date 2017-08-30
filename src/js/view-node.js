// Generated by CoffeeScript 1.12.6
(function() {
  var ViewNode, _, __id__, callResize, checkDom, classMap, create, dirty, dirtyMap, dispose, domList, handleResize, map, nodeMap, performUpdate, rafTimeout, unmap, update,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  _ = require('./utils');

  __id__ = 0;

  nodeMap = {};

  dirtyMap = {};

  classMap = {};

  domList = [];

  dirty = false;

  rafTimeout = null;

  ViewNode = (function() {
    ViewNode.DEBUG = false;

    ViewNode.DEFAULT_CLASS = ViewNode;

    ViewNode.CHECK_DOM = true;

    ViewNode.TAG_KIND = 1;

    ViewNode.TEXT_KIND = 3;

    ViewNode.IGNORES = {
      tag: true,
      clazz: true,
      inject: true,
      keep: true,
      text: true,
      child: true,
      className: true,
      style: true,
      children: true,
      bindings: true
    };

    function ViewNode(cfg) {
      this.update = bind(this.update, this);
      var inject, key, ref, value;
      this.parent = null;
      this.depth = 0;
      this.keep = (ref = cfg != null ? cfg.keep : void 0) != null ? ref : false;
      this.__id__ = ++__id__;
      nodeMap[this.__id__] = this;
      if (_.isNot(this.inject) && cfg && cfg.inject) {
        inject = this.inject = cfg.inject;
        for (key in inject) {
          value = inject[key];
          this[key] = value;
        }
      }
      this.init();
      this.updateCfg(cfg);
      this.populate();
    }

    ViewNode.prototype.appendTo = function(dom) {
      if (this.parent) {
        throw new Error('Please remove node from parent node before adding to the real dom.');
      }
      if (ViewNode.CHECK_DOM) {
        checkDom(dom);
      }
      dom.appendChild(this.view);
      this.onMount();
      this.onAddedToDom();
      return this;
    };

    ViewNode.prototype.behind = function(dom) {
      var next, parent;
      if (this.parent) {
        throw new Error('Please remove node from parent node before adding to the real dom.');
      }
      parent = dom.parentNode;
      next = dom.nextSibling;
      if (ViewNode.CHECK_DOM) {
        checkDom(parent);
      }
      if (next) {
        parent.insertBefore(this.view, next);
      } else {
        parent.appendChild(this.view);
      }
      this.onMount();
      this.onAddedToDom();
      return this;
    };

    ViewNode.prototype.before = function(dom) {
      var parent;
      if (this.parent) {
        throw new Error('Please remove node from parent node before adding to the real dom.');
      }
      parent = dom.parentNode;
      if (ViewNode.CHECK_DOM) {
        checkDom(parent);
      }
      parent.insertBefore(this.view, dom);
      this.onMount();
      this.onAddedToDom();
      return this;
    };

    ViewNode.prototype.replace = function(dom) {
      var parent;
      if (this.parent) {
        throw new Error('Please remove node from parent node before adding to the real dom.');
      }
      parent = dom.parentNode;
      if (ViewNode.CHECK_DOM) {
        checkDom(parent);
        checkDom(dom);
      }
      parent.replaceChild(this.view, dom);
      this.onMount();
      this.onRemovedFromDom();
      return this;
    };

    ViewNode.prototype.remove = function() {
      var parent;
      if (this.parent) {
        throw new Error('Please remove node from parent node instead of removing from real dom.');
      }
      parent = node.view.parentNode;
      if (ViewNode.CHECK_DOM) {
        checkDom(parent);
      }
      parent.removeChild(this.view);
      this.onUnmount();
      return this;
    };

    ViewNode.prototype.init = function() {};

    ViewNode.prototype.updateCfg = function(cfg1) {
      this.cfg = cfg1;
      return true;
    };

    ViewNode.prototype.update = function() {
      return update(this);
    };

    ViewNode.prototype.render = function() {
      return this.cfg;
    };

    ViewNode.prototype.onMount = function() {};

    ViewNode.prototype.onUnmount = function() {
      return this.keep;
    };

    ViewNode.prototype.onAddedToDom = function() {
      var child, j, len, ref;
      if (this.children) {
        ref = this.children;
        for (j = 0, len = ref.length; j < len; j++) {
          child = ref[j];
          child.onAddedToDom();
        }
      }
      return this;
    };

    ViewNode.prototype.onRemovedFromDom = function() {
      var child, j, len, ref;
      if (this.children) {
        ref = this.children;
        for (j = 0, len = ref.length; j < len; j++) {
          child = ref[j];
          child.onRemovedFromDom();
        }
      }
      return this;
    };

    ViewNode.prototype.populate = function() {
      var cfg, tag, text;
      if (this.view) {
        throw new Error("View already exists");
      }
      if (_.isNot(cfg = this.render())) {
        throw new Error("A view for an empty cfg can't be created.");
      }
      if (_.isSimple(cfg)) {
        this.createTextView({
          text: cfg
        });
      } else if (_.isString(tag = cfg.tag)) {
        this.createTagView(cfg);
      } else if (_.isDom(cfg)) {
        this.createTagFromDom(null, cfg);
      } else if (_.isDomText(cfg)) {
        this.createTextFromDom(null, cfg);
      } else if (_.isDom(tag)) {
        this.createTagFromDom(cfg, tag);
      } else if (_.isDomText(tag)) {
        this.createTextFromDom(cfg, tag);
      } else if (_.isSimple(text = cfg.text) || _.isFunc(text)) {
        this.createTextView(cfg);
      } else {
        if (_.extendsNode(tag)) {
          throw new Error("A tag must be a string or a HTMLElement, you specified a ViewNode class.");
        }
        throw new Error("A tag must be a string or a HTMLElement.");
      }
      if (ViewNode.CHECK_DOM) {
        domList.push(this.view);
      }
      return this;
    };

    ViewNode.prototype.createTextView = function(cfg) {
      var text;
      text = cfg.text;
      if (_.isFunc(text)) {
        text = text();
      }
      if (!_.isSimple(text)) {
        throw new Error("The text for a text node must be either a string, number or bool or a function returning one of these types.");
      }
      this.text = text + '';
      this.tag = cfg.tag = void 0;
      this.kind = ViewNode.TEXT_KIND;
      this.view = document.createTextNode(text);
      return this;
    };

    ViewNode.prototype.createTextFromDom = function(cfg, dom) {
      var text;
      if (ViewNode.CHECK_DOM) {
        checkDom(dom);
      }
      this.text = dom.nodeValue;
      this.tag = void 0;
      this.kind = ViewNode.TEXT_KIND;
      this.view = dom;
      if (cfg) {
        text = cfg.text;
        if (_.isNot(text)) {
          cfg.text = this.text;
        } else {
          if (_.isFunc(text)) {
            text = text();
          }
          if (!_.isSimple(text)) {
            throw new Error("The text for a text node must be either a string, number or bool or a function returning one of these types.");
          }
          this.text = dom.nodeValue = text + '';
        }
      } else {
        this.cfg = {
          text: this.text + ''
        };
      }
      this.cfg.tag = void 0;
      return this;
    };

    ViewNode.prototype.createTagView = function(cfg) {
      this.tag = cfg.tag;
      this.kind = ViewNode.TAG_KIND;
      this.view = document.createElement(cfg.tag);
      this.updateProps(cfg);
      return this;
    };

    ViewNode.prototype.createTagFromDom = function(cfg, dom) {
      if (ViewNode.CHECK_DOM) {
        checkDom(dom);
      }
      this.tag = dom.nodeName.toLowerCase();
      this.kind = ViewNode.TAG_KIND;
      this.view = dom;
      if (!cfg) {
        this.cfg = {
          tag: this.tag
        };
      } else {
        this.updateProps(cfg);
      }
      return this;
    };

    ViewNode.prototype.updateNow = function() {
      var cfg;
      cfg = this.render();
      if (this.kind === ViewNode.TAG_KIND) {
        this.updateProps(cfg);
      } else {
        this.updateText(cfg);
      }
      return this;
    };

    ViewNode.prototype.updateText = function(cfg) {
      var text;
      if (!_.isString(text = cfg)) {
        if (!_.isString(text = cfg.text)) {
          if (_.isFunc(text)) {
            text = text();
          }
        }
      }
      text += '';
      if (this.text !== text) {
        this.text = this.view.nodeValue = text;
      }
      return this;
    };

    ViewNode.prototype.updateProps = function(cfg) {
      var attr, ignore, key, name, propMap, value;
      this.attrs = this.attrs || {};
      this.events = this.events || {};
      this.children = this.children || [];
      if (cfg.text !== void 0) {
        this.updateChildren([cfg.text]);
        if (ViewNode.DEBUG) {
          if (cfg.child !== void 0) {
            console.warn('child specified while text exists: ', cfg);
          }
          if (cfg.children !== void 0) {
            console.warn('children specified while text exists', cfg);
          }
        }
      } else if (cfg.child !== void 0) {
        this.updateChildren([cfg.child]);
        if (ViewNode.DEBUG) {
          if (cfg.children !== void 0) {
            console.warn('children specified while child exists', cfg);
          }
        }
      } else if (cfg.children !== void 0) {
        if (_.isFunc(cfg.children)) {
          this.updateChildren(cfg.children());
        } else {
          this.updateChildren(cfg.children);
        }
      } else if (this.children.length) {
        this.updateChildren([]);
      }
      if (cfg.className !== void 0 || this.attrs.className !== void 0) {
        this.updateClassName(cfg.className);
      }
      if (cfg.style !== void 0 || this.attrs.style !== void 0) {
        this.updateStyle(cfg.style);
      }
      propMap = {};
      for (key in cfg) {
        propMap[key] = true;
      }
      for (key in this.attrs) {
        propMap[key] = true;
      }
      for (key in this.events) {
        propMap[key] = true;
      }
      ignore = ViewNode.IGNORES;
      for (name in propMap) {
        if (ignore[name]) {
          continue;
        }
        attr = this.attrs[name];
        value = cfg[name];
        if (_.isBool(value) || (_.isNot(value) && _.isBool(attr))) {
          this.updateBool(value, name);
        } else {
          if (name[0] === 'o' && name[1] === 'n') {
            this.updateEvent(value, name);
          } else {
            if (_.isFunc(value)) {
              value = value();
            }
            if (_.isBool(value)) {
              this.updateBool(value, name);
            } else {
              this.updateAttr(value, name);
            }
          }
        }
      }
      return this;
    };

    ViewNode.prototype.updateAttr = function(value, name) {
      var view;
      this.attrs[name] = this.view.getAttribute(name);
      if (this.attrs[name] === value) {
        return;
      }
      view = this.view;
      if (value !== null && value !== void 0) {
        view.setAttribute(name, value);
        view[name] = value;
        this.attrs[name] = value;
      } else {
        view.removeAttribute(name);
        delete view[name];
        delete this.attrs[name];
      }
      return this;
    };

    ViewNode.prototype.updateBool = function(value, name) {
      var view;
      this.attrs[name] = this.view[name];
      if (this.attrs[name] === value) {
        return;
      }
      view = this.view;
      if (_.isNot(value)) {
        view.removeAttribute(name);
        view[name] = false;
        delete this.attrs[name];
      } else if (value === false) {
        view.removeAttribute(name);
        view[name] = false;
        this.attrs[name] = false;
      } else {
        view.setAttribute(name, '');
        view[name] = true;
        this.attrs[name] = true;
      }
      return this;
    };

    ViewNode.prototype.updateClassName = function(value) {
      if (_.isFunc(value)) {
        value = value();
      }
      this.attrs.className = this.view.className;
      if (this.attrs.className === value) {
        return;
      }
      if (value) {
        this.view.className = value;
        this.attrs.className = value;
      } else {
        this.view.className = void 0;
        delete this.attrs.className;
      }
      return this;
    };

    ViewNode.prototype.updateStyle = function(value) {
      var attrs, changed, css, key, name, prop, propMap, style, v, view;
      view = this.view;
      attrs = this.attrs;
      style = attrs.style;
      if (_.isFunc(value)) {
        value = value();
      }
      if (_.isNot(value)) {
        if (style !== value) {
          view.style.cssText = null;
          delete attrs.style;
        }
      } else if (_.isString(value)) {
        if (style !== value) {
          view.style.cssText = value;
          attrs.style = value;
        }
      } else {
        css = '';
        style = _.isObject(style) ? style : {};
        changed = false;
        propMap = {};
        for (key in style) {
          propMap[key] = true;
        }
        for (key in value) {
          propMap[key] = true;
        }
        for (name in propMap) {
          v = value[name];
          changed = changed || v !== style[name];
          style[name] = v;
          if (_.isNot(v)) {
            delete style[name];
          } else {
            prop = _.normalizeName(name);
            css += prop + ': ' + v + '; ';
          }
        }
        if (changed) {
          if (css.length) {
            css = css.slice(0, -1);
            view.style.cssText = css;
          } else {
            view.style.cssText = null;
            delete attrs.style;
          }
        }
      }
      return this;
    };

    ViewNode.prototype.updateEvent = function(callback, name) {
      var listener, type;
      type = _.normalizeEvent(name);
      listener = this.events[name];
      if (_.isString(callback)) {
        callback = this[name];
      }
      if (listener !== callback) {
        if (listener) {
          this.view.removeEventListener(type, listener);
          delete this.events[name];
        }
        if (callback) {
          this.view.addEventListener(type, callback);
          this.events[name] = callback;
        }
      }
      return this;
    };

    ViewNode.prototype.removeEvents = function() {
      var events, listener, name, type, view;
      events = this.events;
      if (!events) {
        return null;
      }
      view = this.view;
      for (name in events) {
        listener = events[name];
        type = _.normalizeEvent(name);
        if (listener) {
          view.removeEventListener(type, listener);
        }
      }
      this.events = {};
      return this;
    };

    ViewNode.prototype.updateChildren = function(cfgs) {
      var cfg, child, children, hasCfg, i, j, l, newL, oldL, ref;
      children = this.children;
      if (_.isSimple(cfgs)) {
        cfgs = [cfgs];
      }
      oldL = children.length;
      newL = cfgs.length;
      l = oldL > newL ? oldL : newL;
      for (i = j = 0, ref = l; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
        child = children[i];
        cfg = cfgs[i];
        if (_.isFunc(cfg)) {
          cfg = cfg();
        }
        hasCfg = cfg !== void 0 && cfg !== null;
        if (!child && !hasCfg) {
          throw new Error(("DOM ERROR: either child or cfg at index " + i + " must be defined. Got ") + child + ', ' + cfg);
        }
        if (!child && hasCfg) {
          this.addChild(cfg);
        } else if (child && !hasCfg) {
          this.removeChild(child);
        } else {
          this.changeChild(child, cfg);
        }
      }
      if (newL !== oldL && newL !== children.length) {
        children.length = newL;
      }
      return this;
    };

    ViewNode.prototype.addChild = function(childOrCfg) {
      var cfg, child, keep;
      cfg = childOrCfg;
      if (_.isNodeInstance(cfg)) {
        child = cfg;
        if (child.parent) {
          keep = child.keep;
          child.keep = true;
          child.parent.removeChild(child);
          child.keep = keep;
        }
      } else {
        if (!cfg.inject) {
          cfg.inject = this.inject;
        }
        child = create(cfg);
      }
      child.parent = this;
      child.depth = this.depth + 1;
      this.children.push(child);
      this.view.appendChild(child.view);
      child.onMount();
      return child;
    };

    ViewNode.prototype.removeChild = function(child) {
      this.view.removeChild(child.view);
      dispose(child);
      return child;
    };

    ViewNode.prototype.changeChild = function(child, cfg) {
      if (_.isNodeInstance(cfg)) {
        if (child === cfg) {
          child.updateNow();
        } else {
          child = this.replaceChild(child, cfg);
        }
      } else if (_.isString(child.tag)) {
        if (child.tag === cfg.tag || child.constructor === cfg.tag) {
          if (child.updateCfg(cfg)) {
            child.updateProps(child.render());
          }
        } else {
          child = this.replaceChild(child, cfg);
        }
      } else if (_.isSimple(child.text)) {
        if (_.isSimple(cfg) || _.isSimple(cfg.text)) {
          if (child.updateCfg(cfg)) {
            child.updateText(child.render());
          }
        } else {
          child = this.replaceChild(child, cfg);
        }
      } else {
        child = this.replaceChild(child, cfg);
      }
      return child;
    };

    ViewNode.prototype.replaceChild = function(child, newChildOrCfg) {
      var cfg, children, i, keep, view;
      cfg = newChildOrCfg;
      children = this.children;
      i = children.indexOf(child);
      view = child.view;
      dispose(child);
      if (_.isNodeInstance(cfg)) {
        child = cfg;
        if (child.parent) {
          keep = child.keep;
          child.keep = true;
          child.parent.removeChild(child);
          child.keep = keep;
        }
      } else {
        if (!cfg.inject) {
          cfg.inject = this.inject;
        }
        child = create(cfg);
      }
      children[i] = child;
      child.parent = this;
      child.depth = this.depth + 1;
      this.view.replaceChild(child.view, view);
      return child;
    };

    return ViewNode;

  })();

  checkDom = function(dom) {
    if (domList.indexOf(dom) > -1) {
      throw new Error('Dom element already controlled by another node.');
    }
    return dom;
  };

  create = function(cfg) {
    var clazz, dom, tag;
    if (!_.extendsNode(clazz = cfg.clazz || cfg.tag)) {
      clazz = null;
      if (_.isDom(dom = cfg) || _.isDom(dom = cfg.tag)) {
        tag = dom.nodeName.toLowerCase();
      }
      if (_.isString(tag = tag || cfg.tag)) {
        clazz = classMap[tag];
      }
    }
    clazz = clazz || ViewNode.DEFAULT_CLASS;
    return new clazz(cfg);
  };

  dispose = function(node) {
    var child, j, len, ref;
    if (node.onUnmount() !== true) {
      node.removeEvents();
      if (node.children && node.children.length) {
        ref = node.children;
        for (j = 0, len = ref.length; j < len; j++) {
          child = ref[j];
          dispose(child);
        }
      }
      delete node.children;
      delete node.view;
      delete nodeMap[node.__id__];
    }
    node.parent = null;
    node.depth = void 0;
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
      if (!node.view || !nodeMap[node.__id__] || !dirtyMap[node.__id__]) {
        continue;
      }
      node.updateNow();
    }
    dirtyMap = {};
    return null;
  };

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

  callResize = function(node) {
    var child, j, len, ref;
    if (node.onResize) {
      node.onResize();
    }
    if (node.children) {
      ref = node.children;
      for (j = 0, len = ref.length; j < len; j++) {
        child = ref[j];
        callResize(child);
      }
    }
    return node;
  };

  handleResize = function() {
    var key, node;
    for (key in nodeMap) {
      node = nodeMap[key];
      if (!node.parent && node.view) {
        callResize(node);
      }
    }
    return null;
  };

  window.addEventListener('resize', handleResize);

  ViewNode.create = create;

  ViewNode.map = map;

  ViewNode.unmap = unmap;

  module.exports = ViewNode;

}).call(this);

//# sourceMappingURL=view-node.js.map
