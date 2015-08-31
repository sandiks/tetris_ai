require_relative  'game'
require_relative  'helper'


def test_piece
  map = Map.new

  rr_lines = [
    "0 1 2 2 2 3 0 0 0 0 0",
  ]
  gg = [0,0,0,0,0,1,0,0,0,0,0]



  map.rr = rr_lines[0].split(' ').map{|x| x.to_i}
  map.gaps = gg

  arr = "II"
  ss=arr.size

  for i in 0..ss-1

    p "-----round #{i+1}"
    curr_p = arr[i]
    next_p = arr[i+1]
    start = [3,-1]
    #break if next_p.nil?

    prev_rr = map.rr.clone


    p Bot.make_test_round(map, curr_p, next_p)

    #show_field_h(map,prev_rr)
    #clean_lines(map)

  end

end


test_piece
