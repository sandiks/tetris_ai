require_relative  'game'
require_relative  'helper'


def test_piece

  gg = Game.new
  map = gg.map

  rr_lines = [
    ["0 3 3 3 2 3 2 2 2 3 2","JLSSSZTIZL","0 0 2 0 0 0 0 1 0 0 0"],
    ["0 1 5 6 5 6 4 4 6 6 5","IZI","0 0 0 0 0 0 0 0 1 0 0"],
    ["0 2 3 4 4 4 4 4 4 3 4","OSLLILOLILIZOTTOOZZZTZSLIJTSTISII","0 0 0 3 0 0 1 0 0 2 0"],           #6s
  ]

  ll=1

  line = rr_lines[ll][0]
  arr = rr_lines[ll][1]
  gg = rr_lines[ll][2]

  map.rr=line.split(' ').map{|x| x.to_i}
  map.gaps = gg.split(' ').map{|x| x.to_i}
  map.fill_field_by_rr

  ss=arr.size

  for i in 0..ss

    p "***round #{i+1}"
    map.curr_piece = arr[i]
    map.next_piece = arr[i+1]
    break if map.next_piece.nil?

    Bot.make_test_round(gg)
    map.show

  end

end
test_piece
