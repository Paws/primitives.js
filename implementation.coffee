`                                                                                                                 /*|*/ require = require('../../Library/cov_require.js')(require)`
module.exports = implementation:
   
   version: Alien.synchronous -> new Label require('../../package.json').version
   
   console:
      print: new Execution (label)-> console.log label.alien
      inspect: new Execution (thing)-> console.log thing.inspect()
   
   # I don't like this. The semantics of “what stop() means” are waaaaay too complex (or just
   # wishy-washy) for everyday users. Going to get rid of it.
   stop: new Execution (_, here)-> here.stop()
   
   debugger: Alien.synchronous ->
      debugger
      new Label 'debugger'
      
   void: new Alien(
      (caller, $)->
         @caller = caller
         @original = this
         $.stage @caller, @original.clone()
      (_, $)->
         $.stage @caller, @original.clone()
   )
