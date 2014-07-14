`                                                                                                                 /*|*/ require = require('../../Library/cov_require.js')(require)`

Rule = require '../rule.coffee'


module.exports
   .specification = specification = new Object

specification.rule = (title, body)->
   rule = new Rule this, title, body
   
   locals =
      pass: new Native -> rule.pass()
      fail: new Native -> rule.fail()
      
      eventually: new Native (block, here)=>
         rule.eventually block
         here.stage this.caller, new Thing # FIXME: meaningless result (but it's tests, so ...)
      
      # Not convinced these are necessary, but for the moment, they're lending ease to the tests.
      expect:
         explodable: (it)-> if it instanceof Label     then return it else return null
         stagable:   (it)-> if it instanceof Execution then return it else return null
   
   rule.maintain_locals Thing.with(names: yes).construct locals
   rule.inject          Thing.with(names: yes).construct {eventually: locals.eventually}
   
   return rule
