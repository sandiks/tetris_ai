require_relative  'helper'

class Bot

  def self.make_movies(gg)

    map = gg.map
    start = gg.this_piece_position
    map.curr_piece = curr_p= gg.this_piece_type
    map.next_piece = next_p= gg.next_piece_type

    map.parse_from(gg.my.field)

    moves = []

    res = BBGaps.process_gaps(map,start)
    if not res.nil?
      moves+=res
      return moves.join(',')
    end

    best_pos = Bot.process_piece(map)

    if not best_pos.nil?
      moves+=Bot.build_moves(map,curr_p,start,best_pos)
    else
      moves+=["no_moves"]
    end

    moves.join(',')

  end

  def self.process_piece(map)

    poss_with_diff = BlackBox.anlz(map)

    best_pos_info = poss_with_diff.sort_by{|v| v[:sum]}.first
    best_pos = best_pos_info[:cpos]
  end

  def self.make_test_round(map, test_pos=nil)

    start = [3,-1]
    moves = []

    curr_p =map.curr_piece
    next_p =map.next_piece


    res = BBGaps.process_gaps(map,start)
    p "gaps #{res}"
    if not res.nil?
      moves+=res
      return moves.join(',')
    end

    if test_pos.nil?
      poss_with_diff = BlackBox.anlz(map, true)

      best_pos_info = poss_with_diff.sort_by{|v| v[:sum]}.first
      best_pos = best_pos_info[:cpos]
    else
      best_pos = test_pos
    end

    #map.curr_pos = best_pos

    removed=Bot.set_piece(map, curr_p, best_pos)
    p "curr=#{curr_p} next=#{next_p} info: #{best_pos_info} removed lines=#{removed}"

  end

  def self.build_moves(map, ptype, start, pos, need_drop=true)

    rr = map.rr

    turnes = calc_turnes(ptype, pos[1])
    start[0]+=turnes[:shift_x]
    #start[1]-=turnes[:shift_y]
    i = pos[0][0]

    diff_x =  i-start[0]-1
    diff_y =  map.h-2-rr[i]-turnes[:shift_y]

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
  
  def self.set_piece(map, curr_piece, pos)

    map.repl4

    rr = map.rr
    ff = map.field
    gg = map.gaps

    i = pos[0][0]
    h = pos[0][1]+1
    orient = pos[1]

    return if h>20

    case curr_piece

    when 'I'
      case orient
      when 0; ff[i][h],ff[i+1][h],ff[i+2][h],ff[i+3][h]='4','4','4','4'
      when 1; ff[i][h..h+3]="4444"
      end
    when 'O'; ff[i][h..h+1]='44';ff[i+1][h..h+1]='44';
    when 'L'
      case orient
      when 0; ff[i][h],ff[i+1][h],ff[i+2][h]='4','4','4';ff[i+2][h+1]='4';
      when 1; ff[i][h+2]='4'; ff[i+1][h..h+2]='444';
      when 2; ff[i][h+1],ff[i+1][h+1],ff[i+2][h+1]='4','4','4';ff[i][h]='4';
      when 3; ff[i][h..h+2]='444'; ff[i+1][h]='4';
      end
    when 'J'
      case orient
      when 0; ff[i][h],ff[i+1][h],ff[i+2][h]='4','4','4';ff[i][h+1]='4';
      when 1; ff[i][h]='4'; ff[i+1][h..h+2]='444';
      when 2; ff[i][h+1],ff[i+1][h+1],ff[i+2][h+1]='4','4','4';ff[i+2][h]='4';
      when 3; ff[i][h..h+2]='444'; ff[i+1][h+2]='4';
      end
    when 'T'
      case orient
      when 0; ff[i][h],ff[i+1][h],ff[i+2][h]='4','4','4';ff[i+1][h+1]='4';
      when 1; ff[i][h+1]='4'; ff[i+1][h..h+2]='444';
      when 2; ff[i][h+1],ff[i+1][h+1],ff[i+2][h+1]='4','4','4';ff[i+1][h]='4';
      when 3; ff[i][h..h+2]='444'; ff[i+1][h+1]='4';
      end
    when 'Z'
      case orient
      when 0; ff[i][h+1]='4'; ff[i+1][h..h+1]='44';ff[i+2][h]='4';
      when 1; ff[i][h..h+1]='44'; ff[i+1][h+1..h+2]='44';
      end
    when 'S'
      case orient
      when 0; ff[i][h]='4'; ff[i+1][h..h+1]='44';ff[i+2][h+1]='4';
      when 1; ff[i][h+1..h+2]='44'; ff[i+1][h..h+1]='44';
      end

    end
    map.fill_rr
    map.clean_lines

  end

end
