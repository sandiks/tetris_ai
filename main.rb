#!/usr/bin/env ruby


require_relative  'game'
require_relative  'helper'



def main
  gg = Game.new
  stt = Settings.new

  loop do


    s = gets

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

      puts Bot.make_movies(gg)
      
      $stdout.flush
    end


  end

end

main
