`                                                                                                                 /*|*/ require = require('../../Library/cov_require.js')(require)`
module.exports = infrastructure:
   
   empty:   Alien.synchronous ->
               new Thing
   
   get:     Alien.synchronous (it, idx)->
               return it.at numberish idx
   set:     Alien.synchronous (it, idx, to)->
               it.set numberish(idx), to
               console.log it.metadata[numberish idx]
               return null
   cut:     Alien.synchronous (it, idx)->
               idx = numberish idx
               result = it.at idx
               delete it.metadata[idx]
               return result

# FIXME: I need to replace this `parseInt` call. Hell, I need to *spec* how number-strings are
#        supposed to be used. #iamaterribleperson >,>
numberish = (number)->
   number = parseInt number.alien, 10 if number instanceof Label
   return 0 if not _.isNumber number or isNaN number
   return number
