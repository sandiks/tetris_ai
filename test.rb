require_relative  'helper'


what=2


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
      update_player(arr, gg.my) if arr[1] == stt.your_bot
      update_player(arr, gg.other) if arr[1] != stt.your_bot

    when "action"
      currp=gg.this_piece_type

      startr = 0
      endr=startr+100
      next if gg.round<startr || gg.round >endr

      map = gg.map

      p "-------round #{gg.round}"
      if gg.round==startr || true
        map.parse_from(gg.my.field)
      end
      #map.show

      start= gg.this_piece_position
      map.curr_piece= gg.this_piece_type
      map.next_piece= gg.next_piece_type

      res<<map.curr_piece

      Bot.make_test_round(gg)
      map.show
    end
  end
  p res

end

path = '/tmp/out.txt'
#$stdout = STDOUT
#$stdout = File.new(path, 'w')

test_map if what==1
test_main if what==2
#system "chromium "+ path
