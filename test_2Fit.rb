require_relative  'game'
require_relative  'helper'


def test_fit
  templ = "0 0 0"
  rr=[0,2,3,2,2,1,0,1,0,0,0]
 
  p BBLogic.fit_tmpl(8,templ, rr)

end


test_fit