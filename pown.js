/**(c) 2014 Zach Pomerantz; github.com/zzmp/pown
 * # POWN eventing system
 * ### A 100 SLOC mangling of the JavaScript eventing system
 *
 * `pown` your objects using `obj.prototype = Object.create(pown);`
 * That's right - don't even worry about your constructor - that's
 * some pseudo-classical garbage. You *powned* it.
 */

(function (root, factory) {
  if (typeof define === 'function' && define.amd) {
    define(factory);
  } else if (typeof exports === 'object') {
    module.exports = factory();
  } else {
    root.pown = factory();
  }
}(this, function() {
  // pown that prototype
  var pown = {};

  pown.on = function (event, callback, context) {
    var listener = {
      callback: callback,
      context: context || this
    };
    var events = this._events || (this._events = {});
    (events[event] || (events[event] = [])).push(listener);

    return this;
  };

  pown.off = function (event, callback, context) {
    if (!this._events || !this._events[event]) return this;

    var oList = this._events[event];
    var list = this._events[event] = [];

    switch (arguments.length) {
      case 3:
      case 2:
        var listener = {
          callback: callback,
          context: context || this
        };
        for (var i = 0; i < oList.length; i++) {
          if ( oList[i].callback !== listener.callback ||
             !(context === undefined || context === listener.context) ) {
            list.push(oList[i]);
          }
        }
      case 1:
        break;
      case 0:
        this._events = {};
    }

    return this;
  };

  pown.trigger = function (event) {
    if (!this._events || !this._events[event]) return this;

    var list = this._events[event];
    var l = list.length;

    var options = Array.prototype.slice.call(arguments, 1);
    for (var i = 0; i < l; i++) {
      var listener = list[i];
      listener.callback.apply(listener.context, [this].concat(options));
    }

    return this;
  };

  pown.set = function (prop, val) {
    var props = this.props || (this.props = {});
    var oVal = props[prop];
    if (oVal === val) return val;

    props[prop] = val;
    this.trigger('change', {
      p: prop,      // property
      o: oVal,      // original value
      w: undefined, // why not?
      n: val        // new value
    });

    return val;
  };

  pown.get = function (prop) {
    var props = this.props || (this.props = {});

    return props[prop];
  };

  return pown;
}) );
// 100 SLOC                           - *powned* (MIT License)