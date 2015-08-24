require_relative  'game'
require_relative  'helper'



def test_piece
  map = Map.new


  rr_lines = [
    ["0 8 8 9 6 8 8 8 7 6 6","TL"],
    ["0 1 4 4 2 3 4 4 4 2 0","TL"],
    ["0 0 3 3 3 4 4 3 4 3 3","TSTSLZJOSJII"],
  ]

  ll=2
  line = rr_lines[ll][0]
  arr = rr_lines[ll][1]

  map.rr=line.split(' ').map{|x| x.to_i}

  p "initial map"
  show_field_h(map)

  ss=arr.size

  for i in 0..0

    p "***round #{i+1}"
    map.curr_piece = arr[i]
    map.next_piece = arr[i+1]
    break if map.next_piece.nil?

    prev_rr = map.rr.clone
    Bot.make_test_round(map,[1, 3, 7, "d1 0"])

    show_field_h(map,prev_rr)

  end

end
test_piece
