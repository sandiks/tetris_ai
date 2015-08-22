require_relative  'game'
require_relative  'helper'



def test_piece
  map = Map.new

  rr_lines = [
    "0 3 3 3 3 0 2 4 4 4 2",
    "0 1 3 4 4 4 3 3 4 3 4",
    #{}"0 1 1 1 0 0 1 2 2 2 2",
  ]


  rr_lines.each do |line|
    p "--------line #{line}"

    map.rr=line.split(' ').map{|x| x.to_i}

    arr = "OIIII"
    ss=arr.size

    for i in 0..ss-1

      p "***round #{i+1}"
      curr_p = arr[i]
      next_p = arr[i+1]
      break if next_p.nil?
      prev_rr = map.rr.clone
      Bot.make_test_turn(map, curr_p, next_p)

      show_field_h(map,prev_rr)

    end
  end
end

test_piece
