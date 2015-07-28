
require_relative  'game'
require_relative  'helper'



def main
  gg = Game.new
  stt = Settings.new

  pieces = ['I','J','L','O','S','Z','T']
  inp_sett = ["settings timebank 10000",
              "settings time_per_move 500",
              "settings player_names player1,player2",
              "settings your_bot player1",
              "settings field_height 20",
              "settings field_width 10",
              ]

  inp_update = [
    "update game round 1",
    "update game this_piece_type O",
    "update game next_piece_type I",
    "update player1 row_points 0",
    "update player1 combo 0",
    "update player1 field 0,0,0,0,1,1,0,0,0,0;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0"
  ]


  (inp_sett+inp_update).each do |line|
    arr = line.split(' ')
    case arr[0]
    when "settings"
      set_settings(arr,stt)
    when "update"
      update_game(arr, gg) if arr[1] == 'game'
      update_player(arr, gg.my) if arr[1] == stt.your_bot
    when "action"


    end
  end
  p stt
  p gg
end

main
