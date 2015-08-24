

require_relative  'helper'

what=0




def test_map
  map = Map.new
  #arr = File.readlines('setosan.game')[1].split(' ')
  #arr = "OISSLOOTSOJSTIZJLIOSZJLILZJOZJSJOLIZ"
  #arr = "ZTSJSSJOISJOSLSTIJOLJJTLZSZOOJJLILZSJTSSJZOSJIZI" #my test
  arr="LISIZLZO"
  ss=arr.size

  for i in 0..ss

    p "-----round #{i+1}"
    map.curr_piece = arr[i]
    map.next_piece = arr[i+1]
    break if map.next_piece.nil?

    Bot.make_test_round(map)
    map.show

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

      Bot.make_test_round(map, curr_p, next_p)

    end
  end
  p res

end

path = '/tmp/out.txt'
#$stdout = STDOUT
#$stdout = File.new(path, 'w')

test_map if what==0
test_main if what==1
#system "firefox "+ path
