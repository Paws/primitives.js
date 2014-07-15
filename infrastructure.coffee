`                                                                                                                 /*|*/ require = require('../../Library/cov_require.js')(require)`
Paws = require '../Paws.coffee'

module.exports =
-> Paws.Thing.with(names: yes).construct infrastructure:
   
   # ### Procedures for all `Thing`s
   
   empty:      -> new Thing
   
   get:        (it, idx)-> return it.at numberish idx
   set:        (it, idx, to)->   it.set numberish(idx), to    ; return null
   cut:        (it, idx)->
                  idx = numberish idx
                  result = it.at idx
                  delete it.metadata[idx]
                  return result
   
   affix:       (it, other)-> it.push other     ; return null
   unaffix:     (it)-> return it.pop()
   prefix:      (it, other)-> it.unshift other  ; return null
   unprefix:    (it)-> return it.shift()
   
   length:      (it)-> return new Label it.metadata.length - 1
   
   find:        (it, other)-> return new Thing it.find(other)...
   
   # FIXME: Not happy with this, at the moment. I'm staunchly against meaningless return-values, and
   #        in this case, `it` is firmly meaningless. Problem is, I still ain't got booleans decided
   #        ... so, could go either way.
   compare:     (it, other)-> if Thing::compare.call it, other then return it else return null
   clone:       (it)->    return Thing::clone.call it
   adopt:       (it, other)->    Thing::clone.call other, it   ; return null
   
   receiver:    (it)-> return it.receiver
   receive:     (it, receiver)-> it.receiver = receiver        ; return null
   
   own:         (it, idx)-> it.metadata[numberish idx].owned()       ; return null
   disown:      (it, idx)-> it.metadata[numberish idx].disowned()    ; return null
   
   
   # ### Procedures specific to `Label`s
   #---
   # FIXME: Clearly, there's currently no semantic for *checking* if the incoming `Thing` is
   #        actually a `Label` (or rather, duck-typing style, that it has the `Label`-y methods.)
   #        
   #        This remains the case for two reasons:
   #         - there's still no error-handling mechanism in place to interact with such a situation,
   #           if we tested for it
   #         - I'd rather like to avoid revealing to libspace the *type* (that is, in the JavaScript
   #           sense) of an existing value ... it already feels like a hack to me, that there *are*
   #           any "types" to nodes in the data-graph. If libspace wants "can this be exploded?"-
   #           information at runtime, then it should encode that information *into* the data-graph
   #           itself
   label:
      
      clone:    (it)->    return Label::clone.call it
      compare:  (it, other)-> if Label::compare.call it, other then return it else return null
      
      explode:  (it)-> return it.explode()
   
   
   # ### Procedures specific to `Execution`s
   execution:
      
      # TODO: Add an #asynchronous alternative to the super-useful #synchronous, specifically to aid
      #       in the implementation of natives like the following
      branch: new Native(
         (caller, $)->
            @caller = caller
            $.stage caller, this
         (it, $)->
            clone = (if it instanceof Native then Native else Execution)::clone.call it
            if it == @caller
               $.stage clone, @caller
               $.stage @caller, clone
            else # it != @caller
               $.stage @caller, clone
      )
      
      # XXX: ... this seems too easy.
      # TODO: meaningless return value, clearly, but ... how the fuck does one stage `stage`, then?
      stage:   (it, value)->
                  @unit.stage it, value
                  return value
      
      # NOTE: A noop, 'cuz the default receiver (call-pattern) involves unstaging.
      unstage: new Native -> # noop
      
      # FIXME: yadda yadda meaningless arguments
      charge:    undefined # NYI
      discharge: undefined # NYI
      

# FIXME: I need to replace this `parseInt` call. Hell, I need to *spec* how number-strings are
#        supposed to be used. #iamaterribleperson >,>
numberish = (number)->
   number = parseInt number.alien, 10 if number instanceof Label
   return 0 if not _.isNumber number or isNaN number
   return number
