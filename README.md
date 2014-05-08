pown
====

A 100 SLOC mangling of the JavaScript eventing system.

---

* Delegate to it from your own constructed objects!

 `pown` your objects using `obj.prototype = Object.create(pown);`
 That's right - don't even worry about your constructor - that's
 some pseudo-classical garbage. You *powned* it.
 
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

obj.set('frequency', 440)
/**
 * Triggers callbacks registered to 'change'
 * as callback(obj, {
 *   p: property,
 *   o: oldValue,
 *   w: undefined,
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

obj.trigger('change', 'p', 'o', 'w', 'n', 'e', 'd');
/**
 * Triggers callbacks registered to 'change'
 * as callback(obj, 'p', 'o', 'w', 'n', 'e', 'd');
 */
```

*They're even chainable!*

---

Inspired by [backbone.js](backbonejs.org).

---

Catch me on [github](github.com/zzmp) or the [interwebs](www.garabagne.io).
