require_relative  'game'
require_relative  'helper'


def test_fit
  templ = "u1 0 w".split(' ')
  rr=[0,2,3,2,2,1,0,1,1,1,0]
 
 
  for i in 1..10
    p "#{('0'*rr[i]).ljust(20, ' ')} :#{i}"
  end
  p "--------------"
  p fit_tmpl(9,templ, rr)

end


test_fit