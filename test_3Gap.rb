require_relative  'game'
require_relative  'helper'



def test
  map = Map.new

  line = "0 13 12 14 12 13 11 12 13 12 13"
  gg   = "0 0 0 0 5 0 4 10 0 0 0"
  map.rr=line.split(' ').map{|x| x.to_i}
  map.gaps=gg.split(' ').map{|x| x.to_i}

  pos = [5,1]
  curr_p = 'T'
  next_p = 'I'


  p BBGaps.gap_belows(map,curr_p, pos)

  #Bot.make_test_turn(map, curr_p, next_p)

end

test
