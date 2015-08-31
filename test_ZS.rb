require_relative  'game'
require_relative  'helper'


def test_piece

  gg=Game.new
  map = gg.map

  rr_lines = [
    ["0 4 4 4 4 3 3 3 4 3 3","LSJJOOL", "0 0 0 0 3 2 0 0 0 0 1"],
    ["0 4 6 7 5 7 7 5 5 4 1","JZJJZSZLLTOZ", "0 0 0 0 0 0 0 0 0 1 0"],
    ["0 1 3 4 3 2 4 4 4 3 2","LSLLTTIOIOSLSOTLLSSOZSOOTITZSSTZSI", "0 0 0 0 0 1 0 0 0 0 0"],
    ["0 3 4 2 2 3 5 4 5 4 1","LJILJJZOOZLOTZ", "0 0 0 0 1 0 0 0 0 0 0"],
    ["0 2 3 2 3 3 3 2 3 4 4","SSL", "0 0 0 0 0 0 0 0 0 0 2"], #26 round http://theaigames.com/competitions/ai-block-battle/games/55dba3b835ec1d06d15ccfa8
    ["0 2 5 4 4 4 5 4 5 5 4","OLLZ", "0 1 0 0 0 0 0 0 0 0 2"],

  ]

  ll=2

  line = rr_lines[ll][0]
  arr = rr_lines[ll][1]
  gaps = rr_lines[ll][2]

  map.rr=line.split(' ').map{|x| x.to_i}
  map.gaps = gaps.split(' ').map{|x| x.to_i}
  map.fill_field_by_rr

  ss=arr.size

  for i in 0..ss

    p "***round #{i+1}"
    gg.this_piece_type = arr[i]
    gg.next_piece_type = arr[i+1]

    break if gg.next_piece_type.nil?

    Bot.make_test_round(gg)

    gg.map.show

    puts gg.log


  end
end
test_piece
