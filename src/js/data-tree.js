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
      this.currentPaths = null;
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
      if (owner) {
        addOwner(node, owner, name);
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
        keys = {};
        for (key in props) {
          keys[key] = true;
        }
        for (key in value) {
          keys[key] = true;
        }
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

//# sourceMappingURL=data-tree.js.map
