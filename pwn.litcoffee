```
(c) 2014 Zach Pomerantz; github.com/zzmp/pwn (MIT License)
```

## PWN eventing system
A 100 SLOC mangling of the JavaScript eventing system

`pwn` your objects using `obj.prototype = Object.create pwn`.

That's right - don't even worry about your constructor - that's
some pseudo-classical garbage. You _pwned_ it.

---

This module should be available to the browser or other module loadeers (`commonjs`, `requirejs`, etc.), so we wrap the whole thing in a [Universal Module Definition](https://github.com/umdjs/umd).

    ((factory) =>
      if typeof define is 'function' and define.amd? then define factory 
      else if typeof exports is 'object' then module.exports = factory()
      else @pwn = factory()
    ) factory = ->

### The `pwn` object

      pwn = {}

#### `.on`

- Register event listeners.


      pwn.on = (event, callback, context) ->
        listener =
          callback: callback
          context: context or @

Listeners are stored in hashed arrays. This allows multiple listeners to be registered to the same event.

        events = @_events or @_events = {}
        (events[event] or events[event] = []).push listener

        return @

#### `.off`

- Unregister event listeners.


      pwn.off = (event, callback, context) ->
        return @ if not @_events or not @_events[event]

        oList = @_events[event]
        list = @_events[event] = []

        switch arguments.length

Calling `pwn.off('event', cb[, ctx])` only clears the specified listeners.

          when 3, 2
            listener =
              callback: callback
              context: context or @
            for oListener in oList
              if (oList.callback is not listener.callback) or
              not (not context? or context is listener.context)
                list.push oListener

Calling `pwn.off` clears __all__ event listeners.

          when 0
            @_events = {}

        return @

#### `.trigger`

- Trigger listeners registered to the specified event.


      pwn.trigger = (event, options...) ->
        return @ if not @_events or not @_events[event]

        list = @_events[event]

Trigger everything from a copy of the event-listener list, to avoid recursive additions to that list.

        for listener in list.slice()
          setTimeout (-> listener.callback.apply listener.context, [@].concat options), 0

        return @

#### `.set`

- Set a value on the evented object.


      pwn.set = (prop, val) ->
        props = @props or @props = {}
        wVal = props[prop]
        return if wVal is val

        props[prop] = val

Along with setting the value, any change should trigger a `change` event.

        this.trigger 'change',
          p: prop       # property
          w: wVal,      # worn (old) value
          n: val        # new value

        return val

#### `.get`

- Get a value from the evented object.


      pwn.get = (prop) ->
        props = @props or @props = {}

        return props[prop]

      return pwn