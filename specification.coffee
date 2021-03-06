Paws = require '../Paws.coffee'
Rule = require '../rule.coffee'

{  Thing, Label, Execution, Native
,  Relation, Combination, Position, Mask
,  reactor, parse, debugging, utilities: util                                               } = Paws

{  ENV, verbosity, is_silent, colour
,  emergency, alert, critical, error, warning, notice, info, debug, verbose, wtf       } = debugging

module.exports =
-> Thing.with(names: yes).construct specification:

   rule: (title, body)-> new Rule this, title, body

module.exports.generate_block_locals = (rule)->
   Thing.with(names: yes).construct

      # None of these result. When reached, they're the end of your test.
      pass: new Native -> rule.pass()
      fail: new Native -> rule.fail()
      NYI:  new Native -> rule.NYI()

      eventually: (block)-> rule.eventually block; return rule

      # Not convinced these are necessary, but for the moment, they're lending ease to the tests.
      expect:
         explodable: (it)-> if it instanceof Label     then return it else return null
         stageable:  (it)-> if it instanceof Execution then return it else return null

module.exports.generate_members = (rule)->
   Thing.with(names: yes).construct

      pass: new Native (_,$)-> rule.pass(); $.stage rule.caller, rule if rule.caller
      fail: new Native (_,$)-> rule.fail(); $.stage rule.caller, rule if rule.caller
      NYI:  new Native (_,$)-> rule.NYI();  $.stage rule.caller, rule if rule.caller

      eventually: new Native (block, $)->
         rule.eventually block
         $.stage rule.caller, rule if rule.caller
