Paws = require '../Paws.coffee'

{  Thing, Label, Execution, Native
,  Relation, Combination, Position, Mask
,  reactor, parse, debugging, utilities: util                                               } = Paws

{  ENV, verbosity, is_silent, colour
,  emergency, alert, critical, error, warning, notice, info, debug, verbose, wtf       } = debugging


module.exports =
-> Thing.with(names: yes).construct implementation:

   version: -> return new Label require('../../package.json').version

   console:
      print: new Native (label)-> console.log label.alien         ; return null
      inspect: new Native (thing)-> console.log thing.inspect()   ; return null

   # I don't like this. The semantics of “what stop[] means” are waaaaay too complex (or just
   # wishy-washy) for everyday users. Going to get rid of it.
   stop: new Execution (_, here)-> here.stop()

   debugger: ->
      debugger
      return new Label 'debugger'

   void: new Native(
      (caller, $)->
         @caller = caller
         @original = this
         $.stage @caller, @original.clone()
      (_, $)->
         $.stage @caller, @original.clone()
   )
