require_relative  'helper'

class Bot

  def self.make_movies(gg)

    start = gg.this_piece_position
    curr_p= gg.this_piece_type
    next_p= gg.next_piece_type


    map = gg.map
    map.parse_from(gg.my.field)

    moves = []

    res = BBGaps.process_gaps(map,start,curr_p)
    if not res.nil?
      moves+=res
      return moves.join(',')
    end

    best_pos = BlackBox.process_piece(map, curr_p, next_p)

    if not best_pos.nil?
      moves+=Bot.build_moves(map,curr_p,start,best_pos)
    else
      moves+=["no_moves"]
    end

    moves.join(',')

  end

  def self.make_test_round(map, test_pos=nil)

    start = [3,-1]
    moves = []

    curr_p =map.curr_piece
    next_p =map.next_piece


    res = BBGaps.process_gaps(map,start,curr_p)
    p "gaps #{res}"
    if not res.nil?
      moves+=res
      return moves.join(',')
    end

    if test_pos.nil?
      poss_with_diff = BlackBox.anlz(map, curr_p, next_p,true)

      best_pos_info = poss_with_diff.sort_by{|v| v[:sum]}.first
      best_pos = best_pos_info[:cpos]
    else
      best_pos = test_pos
    end

    #map.curr_pos = best_pos
    p "curr=#{curr_p} next=#{next_p} info: #{best_pos_info}"

    BlackBox.set_piece(map, curr_p, best_pos)

  end

  def self.build_moves(map, ptype, start, pos, need_drop=true)

    rr = map.rr

    turnes = calc_turnes(ptype, pos[1])
    start[0]+=turnes[:shift_x]
    #start[1]-=turnes[:shift_y]

    diff_x =  pos[0]-start[0]-1
    diff_y =  map.h-2-rr[pos[0]]-turnes[:shift_y]

    moves_x = diff_x<0 ? ['left']*(diff_x*-1) : ['right']*(diff_x)

    moves = turnes[:turnes]+moves_x

    if need_drop
      moves += ["drop"]
    else
      moves += ["down"]*(diff_y)
      #moves += ["down#{diff_y}"]
    end

    return moves

  end


end
