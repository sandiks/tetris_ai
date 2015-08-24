require_relative  'game'
require_relative  'helper'



def test_piece
  map = Map.new

  rr_lines = [
    "0 3 3 3 3 0 2 4 4 4 2",
    "0 1 3 4 4 4 3 3 4 3 4",
    #{}"0 1 1 1 0 0 1 2 2 2 2",
  ]

  line =rr_lines[1]
  map.rr=line.split(' ').map{|x| x.to_i}

  arr = "OIIII"
  ss=arr.size

  for i in 0..ss-1

    p "***round #{i+1}"
    map.curr_piece = arr[i]
    map.next_piece = arr[i+1]
    break if map.next_piece.nil?

    prev_rr = map.rr.clone
    Bot.make_test_round(map)

    show_field_h(map,prev_rr)

  end

end

test_piece
