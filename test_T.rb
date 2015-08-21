require_relative  'game'
require_relative  'helper'



def test_piece
  map = Map.new

  rr_lines = [
    ["0 8 8 9 6 8 8 8 7 6 6"],
    ["0 8 8 9 9 8 8 5 8 8 10"],
    ["0 4 5 4 4 4 4 4 4 3 2"],
    ["0 5 3 4 3 2 3 3 1 0 4"],
    ["0 0 3 2 1 2 1 3 2 1 3"],
    ["0 2 2 2 2 4 3 2 2 3 1"],

  ]
  

  rr_lines.each do |line|

    map.rr=line[0].split(' ').map{|x| x.to_i}

    arr = "T"
    ss=arr.size

    for i in 0..ss-1

      p "-----round #{i+1}"
      curr_pt = arr[i]
      next_pt = arr[i+1]

      best_pos = BlackBox.anlz(map, curr_pt, true)
      prev_rr = map.rr.clone

      p "curr=#{curr_pt} next=#{next_pt} best_pos=#{best_pos}"

      Bot.set_piece(map, curr_pt, best_pos)

      show_field_h(map,prev_rr)
      clean_lines(map)
    end
  end
end

test_piece
