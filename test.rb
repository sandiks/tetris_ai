
require_relative  'game'
require_relative  'helper'





def  test_rules
  ptype = 'S'
  p "rules"
  p load_rules(ptype)

  mm = Map.new


  5.times do
    BlackBox.detect_position(mm, ptype)
    show_field(mm)
  end
end

def test_gap
  ptype = 'L'
  mm = Map.new
  mm.rr[1..10] = Array.new(10,1)
  mm.rr[1..2]=[3,3]
  mm.gaps[2]=2

  #p fit_row_line(mm.rr, 5 , ['0','0','0'])
  p check_gaps(mm,ptype)

  #BlackBox.detect_position(mm, ptype)
  #show_field(mm)
end

def  test_moves


  ptype = 'T'
  mm = Map.new
  mm.rr[1..2]=[1,1]

  p BlackBox.detect_position(mm, ptype)

end
test_moves
