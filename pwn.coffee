### (c) 2014 Zach Pomerantz; github.com/zzmp/pwn
 # PWN eventing system
 A 100 SLOC mangling of the JavaScript eventing system
 
 `pwn` your objects using `obj.prototype = Object.create pwn`
 That's right - don't even worry about your constructor - that's
 some pseudo-classical garbage. You *pwned* it.
###

factory = ->
  # pwn that prototype
  pwn = {}

  pwn.on = (event, callback, context) ->
    listener =
      callback: callback
      context: context or @
    events = @_events or @_events = {}
    (events[event] or events[event] = []).push listener

    return @

  pwn.off = (event, callback, context) ->
    return @ if not @_events or not @_events[event]

    oList = @_events[event]
    list = @_events[event] = []

    switch arguments.length
      when 3, 2 then
        listener =
          callback: callback
          context: context or @
        for oListener in oList
          list.push oListener if
            (oList.callback is not listener.callback) or
            not (not context? or context is listener.context)
      when 0 then
        @_events = {}

    return @

  pwn.trigger = (event, options...) ->
    return @ if not this@_events or not @_events[event]

    list = @_events[event]
 
    for listener in list.slice()
      listener.callback.apply listener.context, [@].concat options

    return @

  pwn.set = (prop, val) ->
    props = @props or @props = {}
    oVal = props[prop]
    return if oVal is val

    props[prop] = val
    this.trigger 'change',
      p: prop       # property
      w: wval,      # worn (old) value
      n: val        # new value

    return val

  pwn.get = (prop) ->
    props = @props or @props = {}

    return props[prop]

  return pwn

((root, factory) ->
  if typeof define is 'function' and define.amd? then define factory 
  else if typeof exports is 'object' then module.exports = factory()
  else root.pwn = factory()
)
# 79 SLOC                            - *pwned* (MIT License)
