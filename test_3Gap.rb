require_relative  'game'
require_relative  'helper'


def test

  map = Map.new

  rr = "0 6 6 4 6 7 8 7 6 7 2"
  gg   = "0 0 0 1 0 0 0 0 2 0 0"

  map.rr=rr.split(' ').map{|x| x.to_i}
  map.gaps=gg.split(' ').map{|x| x.to_i}

  map.fill_field_by_rr
  
  map.curr_piece='J'
  map.next_piece='I'

  #Bot.make_test_round(map,[[1,5], 2, 7, "0 d1"])
  Bot.make_test_round(map)

  map.show
end

test
