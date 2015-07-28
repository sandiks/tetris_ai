
require_relative  'game'
require_relative  'helper'



def test_bad_case
  ptype = 'Z'
  mm = Map.new
  mm.rr[1..10] = Array.new(10,6)
  mm.rr[1]=0
  mm.rr[2]=2
  mm.rr[3]=4
  p BlackBox.detect_position(mm, ptype)
end
#test_bad_case

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


  ptype = 'O'

  mm = test_field_parser
  mm.show

  start = [5,20]
  pos=BlackBox.detect_position(mm, ptype)

  p turnes = detect_turnes(ptype,pos[1])
  start[0]+=turnes[:shift_x]
  start[1]-=turnes[:shift_y]

  dif_x = pos[0]-start[0]
  moves_x =   dif_x<0 ? ['left']*(dif_x*-1) : ['right']*dif_x

  p moves = turnes[:turnes]+moves_x+["drop"]
end

def  test_field_parser

  ff_str= "0,0,0,0,1,1,0,0,0,0;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0;2,2,2,2,0,0,0,0,0,0;3,3,3,3,3,3,3,3,3,3"

  mm = Map.new
  mm.parse_from(ff_str)
  mm
 
end



test_moves
