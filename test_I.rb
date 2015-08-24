require_relative  'game'
require_relative  'helper'



def test_piece
  map = Map.new

  rr_lines = [
    "0 2 4 4 0 2 3 3 3 3 2",
    "0 4 4 4 3 3 3 2 5 6 5",
  ]

  map.gaps = [0,1,0,0,0,0,0,0,0,0,0]
  
  c
  map.rr=line.split(' ').map{|x| x.to_i}
  
  show_field_h(map)

  arr = "IJJ"
  ss=arr.size

  for i in 0..0

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
