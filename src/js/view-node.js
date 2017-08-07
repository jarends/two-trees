// Generated by CoffeeScript 1.12.6
(function() {
  var ViewNode, ViewTree, _,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  _ = require('./utils');

  ViewNode = (function() {
    ViewNode.DEBUG = false;

    ViewNode.CHECK_DOM = false;

    ViewNode.DEFAULT_CLASS = ViewNode;

    ViewNode.TEXT_KIND = 0;

    ViewNode.TAG_KIND = 1;

    ViewNode.create = function(cfg) {
      return ViewTree.create(cfg);
    };

    ViewNode.map = function(tag, clazz, overwrite) {
      if (overwrite == null) {
        overwrite = false;
      }
      return ViewTree.map(tag, clazz, overwrite);
    };

    ViewNode.unmap = function(tag) {
      return ViewTree.unmap(tag);
    };

    function ViewNode(cfg) {
      this.update = bind(this.update, this);
      this.register(cfg);
      this.updateCfg(cfg);
      this.updateNow();
    }

    ViewNode.prototype.register = function(cfg) {
      return ViewTree.register(this, cfg);
    };

    ViewNode.prototype.updateNow = function() {
      return ViewTree.updateNow(this);
    };

    ViewNode.prototype.createView = function(cfg) {
      return ViewTree.createView(this, cfg);
    };

    ViewNode.prototype.appendTo = function(dom) {
      return ViewTree.appendTo(this, dom);
    };

    ViewNode.prototype.behind = function(dom) {
      return ViewTree.behind(this, dom);
    };

    ViewNode.prototype.before = function(dom) {
      return ViewTree.before(this, dom);
    };

    ViewNode.prototype.replace = function(dom) {
      return ViewTree.replace(this, dom);
    };

    ViewNode.prototype.remove = function(dom) {
      return ViewTree.remove(this, dom);
    };

    ViewNode.prototype.addChild = function(child) {
      return ViewTree.addChild(this, child);
    };

    ViewNode.prototype.addChildAt = function(child, index) {
      return ViewTree.addChildAt(this, child, index);
    };

    ViewNode.prototype.removeChild = function(child) {
      return ViewTree.removeChild(this, child);
    };

    ViewNode.prototype.removeChildAt = function(index) {
      return ViewTree.removeChildAt(this, index);
    };

    ViewNode.prototype.updateCfg = function(cfg) {
      return (this.cfg = cfg) || true;
    };

    ViewNode.prototype.update = function() {
      return ViewTree.update(this);
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

  if (typeof module !== 'undefined') {
    module.exports = ViewNode;
    ViewTree = require('./view-tree');
  }

  if (typeof window !== 'undefined') {
    window.ViewNode = ViewNode;
  } else {
    this.ViewNode = ViewNode;
  }

}).call(this);

//# sourceMappingURL=view-node.js.map
