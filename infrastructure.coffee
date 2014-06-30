`                                                                                                                 /*|*/ require = require('../../Library/cov_require.js')(require)`
module.exports = infrastructure:
   
   # ### Procedures for all `Thing`s
   
   empty:      Alien.synchronous ->
                  new Thing
   
   get:        Alien.synchronous (it, idx)->
                  return it.at numberish idx
   set:        Alien.synchronous (it, idx, to)->
                  it.set numberish(idx), to
                  return null
   cut:        Alien.synchronous (it, idx)->
                  idx = numberish idx
                  result = it.at idx
                  delete it.metadata[idx]
                  return result
   
   affix:      Alien.synchronous (it, other)->
                  it.push other
                  return null
   unaffix:    Alien.synchronous (it)->
                  return it.pop()
   prefix:     Alien.synchronous (it, other)->
                  it.unshift other
                  return null
   unprefix:   Alien.synchronous (it)->
                 return it.shift()
   
   length:     Alien.synchronous (it)->
                  console.log it.metadata
                  return new Label it.metadata.length - 1
   
   # FIXME: Not happy with this, at the moment. I'm staunchly against meaningless return-values, and
   #        in this case, `it` is firmly meaningless. Problem is, I still ain't got booleans decided
   #        ... so, could go either way.
   compare:    Alien.synchronous (it, other)->
                  if Thing::compare.call it, other then return it else return null
   clone:      Alien.synchronous (it)->
                  return Thing::clone.call it
   adopt:      Alien.synchronous (it, other)->
                  Thing::clone.call other, it
                  return null
   
   receiver:   Alien.synchronous (it)->
                 return it.receiver
   receive:    Alien.synchronous (it, receiver)->
                  it.receiver = receiver
                  return null
   
   own:        undefined # NYI
   disown:     undefined # NYI
   
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
      
      clone:   Alien.synchronous (it)->
                  return Label::clone.call it
      compare: Alien.synchronous (it, other)->
                  if Label::compare.call it, other then return it else return null
      
      explode: Alien.synchronous (it)->
                  return it.explode()
   
   # ### Procedures specific to `Execution`s
   execution:
      
      # TODO: Add an #asynchronous alternative to the super-useful #synchronous, specifically to aid
      #       in the implementation of aliens like the following
      branch: new Alien(
         (caller, $)->
            @caller = caller
            $.stage caller, this
         (it, $)->
            clone = (if it instanceof Alien then Alien else Native)::clone.call it
            if it == @caller
               $.stage clone, @caller
               $.stage @caller, clone
            else # it != @caller
               $.stage @caller, clone
      )
      
      # XXX: ... this seems too easy.
      stage:   Alien.synchronous (it, value)->
                  @unit.stage it, value
      
      # NOTE: A noop, 'cuz the default receiver (call-pattern) involves unstaging.
      unstage: new Alien -> # noop
      
      # FIXME: yadda yadda meaningless arguments
      charge:  undefined # NYI
      discharge: undefined # NYI
      

# FIXME: I need to replace this `parseInt` call. Hell, I need to *spec* how number-strings are
#        supposed to be used. #iamaterribleperson >,>
numberish = (number)->
   number = parseInt number.alien, 10 if number instanceof Label
   return 0 if not _.isNumber number or isNaN number
   return number
