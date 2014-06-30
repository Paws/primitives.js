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
                  return it.clone()
   adopt:      Alien.synchronous (it, other)->
                  other.clone it
                  return null
   
   receiver:   Alien.synchronous (it)->
                 return it.receiver
   receive:    Alien.synchronous (it, receiver)->
                  it.receiver = receiver
                  return null
   
   own:        undefined # NYI
   disown:     undefined # NYI

# FIXME: I need to replace this `parseInt` call. Hell, I need to *spec* how number-strings are
#        supposed to be used. #iamaterribleperson >,>
numberish = (number)->
   number = parseInt number.alien, 10 if number instanceof Label
   return 0 if not _.isNumber number or isNaN number
   return number
