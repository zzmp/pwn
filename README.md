pwn
====

A <100 SLOC mangling of a JavaScript eventing system.

---

* Delegate to it from your own constructed objects!

 `pwn` your objects using `obj.prototype = Object.create(pwn);`
 That's right - don't even worry about your constructor - that's
 some pseudo-classical garbage. You *pwned* it.
 
* Register new event listeners

```javascript
// obj.on(event, callback, context)

obj.on('change', func, this); // register listener with this context
obj.on('change', func); // register listener with obj's context
```

* Unregister old event listeners

```javascript
// obj.off(event, callback, context)

obj.off('change', func, this); // remove like callbacks with like context
obj.off('change', func); // remove like callbacks with any context
obj.off('change'); // remove all registered listeners to 'change'
obj.off(); // remove all registered listeners to all events
```

* Set properties

```javascript
// obj.set(property, value)

obj.set('frequency', 440) // returns 440
/**
 * Triggers callbacks registered to 'change'
 * as callback(obj, {
 *   p: property,
 *   w: wornValue, // (oldValue)
 *   n, value
 * })
 */
```

* Get properties

```javascript
// obj.get(property, value)

obj.get('frequency') // returns 440
```

* Trigger events yourself

```javascript
//obj.trigger(event, options)

obj.trigger('change', 'p', 'w', 'n', 'e', 'd');
/**
 * Triggers callbacks registered to 'change'
 * as callback(obj, 'p', 'w', 'n', 'e', 'd');
 */
```

*They're even chainable (`on`, `off`, and `trigger`)!*

---

Inspired by [backbone.js](backbonejs.org).

---

Catch me on [github](http://www.github.com/zzmp) or the [interwebs](http://garabagne.io).
