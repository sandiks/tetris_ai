

require_relative  'helper'

what=1



def test_best_players
  map = Map.new
  #arr = File.readlines('setosan.game')[1].split(' ')
  #arr = "OISSLOOTSOJSTIZJLIOSZJLILZJOZJSJOLIZ"
  #arr = "ZTSJSSJOISJOSLSTIJOLJJTLZSZOOJJLILZSJTSSJZOSJIZI" #my test
  arr="JJSLLSOZSLSLLLLOIZZOTSJIIJOTJSJISOLOZZLLJST"
  ss=arr.size

  for i in 0..ss-1

    p "-----round #{i+1}"
    curr_p = arr[i]
    next_p = arr[i+1]
    break if next_p.nil?
    
    prev_rr = map.rr.clone
    Bot.make_test_turn(map, curr_p, next_p)

    show_field_h(map,prev_rr)
    clean_lines(map)
  end
end

def test_main
  gg = Game.new
  stt = Settings.new
  res=""

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
      curr_p= gg.this_piece_type
      next_p= gg.next_piece_type

      res<<curr_p

      Bot.make_test_turn(map, curr_p, next_p)

    end
  end
  p res

end

path = '/tmp/out.txt'
#$stdout = STDOUT
$stdout = File.new(path, 'w')

test_best_players if what==1
test_main if what==2
system "firefox "+ path