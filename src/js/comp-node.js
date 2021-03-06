// Generated by CoffeeScript 1.12.6
(function() {
  var CompNode, ViewNode,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  ViewNode = require('./view-node');

  CompNode = (function(superClass) {
    extend(CompNode, superClass);

    function CompNode(cfg) {
      var binding, bindings, i, len;
      CompNode.__super__.constructor.call(this, cfg);
      this.paths = [];
      if (typeof cfg === 'object') {
        if (!this.tree) {
          throw new Error("Tree not injected.");
        }
        if (bindings = cfg.bindings) {
          for (i = 0, len = bindings.length; i < len; i++) {
            binding = bindings[i];
            if (Array.isArray(binding)) {
              this.bind(binding[0], binding[1]);
            } else {
              this.bind(binding);
            }
          }
        }
      }
      this;
    }

    CompNode.prototype.onUnmount = function() {
      this.unbindAll();
      return CompNode.__super__.onUnmount.call(this);
    };

    CompNode.prototype.bind = function(obj, name, callback) {
      return this.paths.push(this.tree.bind(obj, name, callback || this.update));
    };

    CompNode.prototype.unbind = function(paths) {
      var index;
      index = this.paths.indexOf(paths);
      if (index === -1) {
        console.error('Paths not bound by this comp. paths = ', paths);
        throw new Error('Paths not bound by this comp.');
      }
      this.paths.splice(index, 1);
      return this.tree.unbind(paths);
    };

    CompNode.prototype.unbindAll = function() {
      var allUnbound, i, len, paths, ref;
      allUnbound = true;
      ref = this.paths;
      for (i = 0, len = ref.length; i < len; i++) {
        paths = ref[i];
        allUnbound = allUnbound && this.tree.unbind(paths);
      }
      this.paths = [];
      return allUnbound;
    };

    return CompNode;

  })(ViewNode);

  module.exports = CompNode;

}).call(this);

//# sourceMappingURL=comp-node.js.map
