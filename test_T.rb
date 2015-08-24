require_relative  'game'
require_relative  'helper'


def test_piece
  map = Map.new


  rr_lines = [
    ["0 8 8 9 6 8 8 8 7 6 6","TL"],
    ["0 1 4 4 2 3 4 4 4 2 0","TL"],
    ["0 0 3 3 3 4 4 3 4 3 3","TSTSLZJOSLII"],
    ["0 5 3 4 5 5 5 5 6 7 2","TLSJIS"],
    ["0 5 2 4 3 4 2 0 1 3 2","TLZL"],
  ]
  gg = "0 0 0 0 0 0 0 0 0 0 0".split(' ').map{|x| x.to_i}

  ll=4
  line = rr_lines[ll][0]
  arr = rr_lines[ll][1]

  map.rr=line.split(' ').map{|x| x.to_i}
  map.gaps = gg
  map.fill_field_by_rr

  ss=arr.size

  for i in 0..4

    p "***round #{i+1}"
    map.curr_piece = arr[i]
    map.next_piece = arr[i+1]
    break if map.next_piece.nil?

    Bot.make_test_round(map)
    map.show

  end

end
test_piece
