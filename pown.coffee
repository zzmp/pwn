###
 # POWN eventing system - now in CoffeeScript!
 # A 100 SLOC mangling of the <s>JavaScript</s> eventing system
 #
 # `pown` your objects using `obj.prototype = Object.create pown`
 # That's right - don't even worry about your constructor - that's
 # some pseudo-classical garbage. You *powned* it.
 #
 # Your object can now `pown` that minimalist MVC you got going:
 #  obj.on event, callback, context  - *powned*
 #  obj.off event, callback, context - *powned*
 #  obj.off event, callback          - *powned*
 #  obj.off event                    - *powned*
 #  obj.trigger event, options       - *powned*
 #  obj.set property, value          - *powned*
 #  obj.get property, value          - *powned*
###

define ->
  # pown that prototype
  pown = {}

  pown.on = (event, callback, context) ->
    listener =
      callback: callback
      context: context or @
    events = @_events or @_events = {}
    (events[event] or events[event] = []).push listener

    return @

  pown.off = (event, callback, context) ->
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

  pown.trigger = (event, options) ->
    return @ if not this@_events or not @_events[event]

    list = @_events[event]
    l = list.length

    
    for listener in [0...l]
      listener.callback.apply listener.context, [@].concat options

    return @

  pown.set = (prop, val) ->
    props = @props or @props = {}
    oVal = props[prop]

    props[prop] = val
    this.trigger 'change',
      p: prop       # property
      o: oval       # original value
      w: undefined, # why not?
      n: val        # new value

    return @

  pown.get = (prop) ->
    props = @props or @props = {}

    return props[prop]

  return pown

# 84 SLOC                            - *powned* (MIT License)
