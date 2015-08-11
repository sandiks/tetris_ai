
require_relative  'game'
require_relative  'helper'

def test
  map = Map.new
  map.rr = [0,5,5,5,5,5,5,5,5,5,5]

  map.gaps[1]=2
  map.gaps[2]=3

  ptype = 'O'
  0.times do
    p best_pos = BlackBox.anlz(map, ptype)
    Bot.set_piece(map, ptype, best_pos)

    show_field(map)
  end
  clean_lines(map)
  show_field(map)

end

#test

def test_best_players
  map = Map.new
  #arr_pcs = File.readlines('setosan.game')[1].split(' ')
  arr_pcs = "T I J I T O S J O L J Z O L T J L J Z J".split(' ')

  for i in 0..arr_pcs.size-1
    p "-----round #{i+1}"
    curr_pt = arr_pcs[i]
    next_pt = arr_pcs[i+1]

    best_pos = BlackBox.anlz(map, curr_pt)
    p "curr=#{curr_pt} next=#{next_pt} best_pos=#{best_pos}"

    prev_rr = map.rr.clone
    p "prev rr=#{prev_rr}"
    Bot.set_piece(map, curr_pt, best_pos)

    show_field(map, prev_rr)
    clean_lines(map)
  end
end

test_best_players

def test_main
  gg = Game.new
  map = gg.map
  stt = Settings.new

  File.open("cmnds.txt", "r").each do |line|

    s = line

    next if /\S/ !~ s


    arr = s.split(' ')
    case arr[0]

    when "settings"
      set_settings(arr,stt)

    when "update"
      update_game(arr, gg) if arr[1] == 'game'
      update_player(arr, gg.my) if arr[1] == 'player1'
      update_player(arr, gg.other) if arr[1] != stt.your_bot

    when "action"
      start = gg.this_piece_position
      ptype= gg.this_piece_type

      map.parse_from(gg.my.field)
      map.show

      best_pos = BlackBox.anlz(map, ptype)
      #best_pos = find_max_compatibility(all_pos)
      Bot.set_piece(map, ptype, best_pos)

      p "piece #{ptype} start=#{start} best_pos=#{best_pos} all pos="

      p Bot.get_turnes(ptype,start,best_pos)

    end
  end
end
