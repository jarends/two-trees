// Generated by CoffeeScript 1.12.6
(function() {
  var AppView, ViewTree,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  ViewTree = require('../../src/js/view-tree');

  AppView = (function(superClass) {
    extend(AppView, superClass);

    function AppView(cfg) {
      this.redo = bind(this.redo, this);
      this.undo = bind(this.undo, this);
      this.onClick = bind(this.onClick, this);
      this.onGreaterClicked = bind(this.onGreaterClicked, this);
      AppView.__super__.constructor.call(this, cfg);
      this.model = cfg.model;
      this.data = cfg.model.root;
      this.title = this.data.title;
      this.bgGreen1 = this.model.bind(this.data, 'bgGreen', (function(_this) {
        return function(value, obj, name, path) {
          return console.log('bgGreen1 changed: ', value);
        };
      })(this));
      this.bgGreen2 = this.model.bind(this.data, 'bgGreen', (function(_this) {
        return function(value, obj, name, path) {
          return console.log('bgGreen2 changed: ', value);
        };
      })(this));
      this.model.bind(this.data.test, 'bla', (function(_this) {
        return function(value, obj, name, path) {
          return console.log('test.bla changed: ', value);
        };
      })(this));
      this.model.bind(this.data.a[0], null, function(value, obj, name, path) {
        return console.log('a[0] changed: ', value);
      });
      this.model.bind(this.data.a[0], 'hello', function(value, obj, name, path) {
        return console.log('a.0.hello changed: ', value);
      });
      this.model.bind(this.data.a[0], 'helloNew', function(value, obj, name, path) {
        return console.log('a.0.helloNew changed: ', value);
      });
      this.model.bind(this.data.a[0], '*', function(value, obj, name, path) {
        return console.log('a.0.* changed: ', value);
      });
      this.clicks = 0;
      this.greater = ViewTree.create({
        tag: 'h5',
        children: 'greater 128',
        onClick: this.onGreaterClicked
      });
      this.greater.keep = true;
    }

    AppView.prototype.onGreaterClicked = function() {
      return console.log('greater clicked');
    };

    AppView.prototype.onClick = function() {
      this.data.bgGreen = (Math.random() * 200 + 55) >> 0;
      this.data.title = this.title + '!!!!!'.slice((Math.random() * 5) >> 0);
      this.data.a[0].hello = 'world!';
      this.data.a[0] = this.newA = this.newA || {
        helloNew: 'worldNew'
      };
      this.data.test.bla = 'blup';
      this.model.update();
      this.update();
      if (++this.clicks === 5) {
        console.log('unbind bgGreen');
        this.model.unbind(this.bgGreen1);
      }
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
      var children;
      children = [
        {
          tag: 'h1',
          title: 'page title',
          className: 'my-class',
          style: "background-color: rgb(0," + this.data.bgGreen + ",0);",
          onClick: this.onClick,
          children: [
            {
              tag: 'span',
              children: [
                {
                  text: this.data.title
                }
              ],
              __i__: {
                ctx: this
              }
            }
          ]
        }, {
          tag: 'button',
          onClick: this.undo,
          children: 'undo'
        }, {
          tag: 'button',
          onClick: this.redo,
          children: 'redo'
        }
      ];
      if (this.data.bgGreen > 128) {
        children.push(this.greater);
      }
      return {
        tag: 'div',
        children: children
      };
    };

    return AppView;

  })(ViewTree.Node);

  module.exports = AppView;

}).call(this);

//# sourceMappingURL=app-view.js.map
