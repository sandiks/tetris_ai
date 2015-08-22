require_relative  'game'
require_relative  'helper'



def test_piece
  map = Map.new

  rr_lines = [

    ["0 2 4 4 0 2 3 3 3 3 2"],
  ]
  map.gaps = [0,0,0,0,0,3,0,0,0,0,0]

  rr_lines.each do |line|
    p "--------line #{line}"

    map.rr=line[0].split(' ').map{|x| x.to_i}

    arr = "IIIII"
    ss=arr.size

    for i in 0..1

      p "***round #{i+1}"
      curr_p = arr[i]
      next_p = arr[i+1]

      prev_rr = map.rr.clone
      break if next_p.nil?

      Bot.make_test_turn(map, curr_p, next_p)

      show_field_h(map,prev_rr)

    end
  end
end

test_piece
