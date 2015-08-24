require_relative  'game'
require_relative  'helper'


def test_piece
  map = Map.new

  rr_lines = [
    ["0 0 0 0 1 1 2 1 1 1 1","SI"],
    ["0 3 3 1 1 1 2 0 1 3 1","OSI","0 0 0 0 0 0 0 1 0 0 0"],
  ]

  ll=1

  line = rr_lines[ll][0]
  arr = rr_lines[ll][1]
  gg = rr_lines[ll][2]

  map.rr=line.split(' ').map{|x| x.to_i}
  map.fill_field_by_rr
  map.gaps = gg.split(' ').map{|x| x.to_i}

  ss=arr.size

  for i in 0..2

    p "***round #{i+1}"
    map.curr_piece = arr[i]
    map.next_piece = arr[i+1]
    break if map.next_piece.nil?

    Bot.make_test_round(map)
    map.show

  end
end
test_piece
