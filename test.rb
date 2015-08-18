
require_relative  'game'
require_relative  'helper'

what=1

def test
  map = Map.new
  map.rr = [0,6,6,5,6,6,6,5,4,5,1]


  arr = "ZZOOOO"
  ss =arr.size

  for i in 0..ss
    p "-----round #{i+1}"
    curr_pt = arr[i]
    next_pt = arr[i+1]

    best_pos = BlackBox.anlz(map, curr_pt)
    prev_rr = map.rr.clone
    Bot.set_piece(map, curr_pt, best_pos)
    p "curr=#{curr_pt} next=#{next_pt} best_pos=#{best_pos}"

    show_field(map,prev_rr)
    clean_lines(map)
  end


end



def test_best_players
  map = Map.new
  #arr = File.readlines('setosan.game')[1].split(' ')
  #arr = "OISSLOOTSOJSTIZJLIOSZJLILZJOZJSJOLIZ"
  arr = "TZLTZSTLOJZSJJOIOIII" #my test
  ss=arr.size
  for i in 0..ss

    p "-----round #{i+1}"
    curr_pt = arr[i]
    next_pt = arr[i+1]

    best_pos = BlackBox.anlz(map, curr_pt)
    prev_rr = map.rr.clone
    Bot.set_piece(map, curr_pt, best_pos)
    p "curr=#{curr_pt} next=#{next_pt} best_pos=#{best_pos}"
    p Bot.get_turnes(curr_pt,[3,-1],best_pos)

    show_field_h(map,prev_rr)
    clean_lines(map)
  end
end

def test_main
  gg = Game.new
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
      update_player(arr, gg.other) if arr[1] != 'player1'

    when "action"
      p "-------round #{gg.round}"
      map = gg.map

      map.parse_from(gg.my.field)
      map.show
      p map.rr

      start= gg.this_piece_position
      ptype= gg.this_piece_type


      best_pos = BlackBox.anlz(map, ptype)

      p "piece #{ptype} start=#{start} best_pos=#{best_pos}"

      p Bot.get_turnes(ptype,start,best_pos)

      #res= Bot.make_movies(gg).join(',')

    end
  end


end

test if what==1
test_best_players if what==2
test_main if what==3
