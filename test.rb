
require_relative  'game'
require_relative  'helper'



def test_bad_case
  ptype = 'J'
  mm = Map.new
  mm.rr[1..10] = Array.new(10,6)
  mm.rr[9]=3
  mm.rr[8]=3

  p BlackBox.detect_position(mm, ptype)
end


def test_gap
  ptype = 'Z'
  mm = Map.new
  mm.rr[1..10] = Array.new(10,3)
  mm.rr[1]=0
  mm.rr[2]=2

  #p fit_row_line(mm.rr, 5 , ['0','0','0'])
  p check_gaps(mm,ptype)

  #BlackBox.detect_position(mm, ptype)
  #show_field(mm)
end

def  test_moves

  ptype = 'I'

  mm = test_field_parser
  mm.show

  p Bot.make_movies(mm,[4,-1],ptype)
end



def  test_field_parser

  ff_str= "0,0,0,0,1,1,0,0,0,0;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0;2,2,2,2,0,0,0,0,0,0;3,3,3,3,3,3,3,3,3,3"

  mm = Map.new
  mm.parse_from(ff_str)
  mm

end
test_moves