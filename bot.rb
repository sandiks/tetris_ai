require_relative  'helper'

class Bot

  def self.make_test_round(gg, test_pos=nil)

    map = gg.map

    start = [3,-1]
    moves = []

    curr_p=map.curr_piece= gg.this_piece_type
    next_p=map.next_piece= gg.next_piece_type
    gg.log=[]

    #map.start_force_mode


    res = BBGaps.process_gaps(map,start)
    #p "gaps #{res}"
    if not res.nil?
      moves+=res
      return moves.join(',')
    end

    if test_pos.nil?
      all = BlackBox.anlz(map)
      best=find_best(all,gg)

      best_pos=best[:pos]
    else
      best_pos = test_pos
    end

    #p "formula: new_level+min_gap+new_gap[x2 if deleted==0]-removed"
    remvd=Bot.set_piece(map, curr_p, best_pos)

    if remvd.size>0
      gg.my.combo+=1
    else
      gg.my.combo=0
    end
    map.combo = gg.my.combo

    gg.log << "round:#{gg.round} best:#{curr_p} pos: #{best_pos} factor:#{best[:factor]} gap:#{best[:gap]} removed:#{best[:removed]} sum:#{best[:sum]} NEXT=#{best[:best_next]}"
    #p "****level 0"
    all.each { |e| gg.log << "#{e[:piece]}: pos: #{e[:pos].to_s.ljust(35,' ')}  f:#{e[:factor]} g:#{e[:gap]} rem:#{e[:removed]} sum:#{e[:sum]}"  }

  end

  def self.find_best(all,gg)

    #is_force = gg.map.force_mode 
    gg.map.force_mode=is_force = gg.need_force_mode?
    
    combo = gg.my.combo
    if combo>0 && !is_force
      all.each do |el|
        if el[:removed]>0
          el[:next].each { |e| e[:sum]-=combo+1 if e[:removed]>0  }
          el[:sum]-=(2*combo+1)
        end
      end
    end

    if is_force
      best = all.select { |x| x[:removed]==0 }.min_by{|x| x[:sum]}
    else
      best = all.min_by{|x| x[:sum]}
    end
  end

  def self.make_movies(gg)

    map = gg.map
    start = gg.this_piece_position
    map.curr_piece = gg.this_piece_type
    map.next_piece = gg.next_piece_type

    map.parse_from(gg.my.field)

    moves = []
    if gg.round<10
      res = BBGaps.process_gaps(map,start)
      if not res.nil?
        moves+=res
        return moves.join(',')
      end
    end

    all = BlackBox.anlz(map)
    best=find_best(all,gg)
    best_pos = best[:pos]

    if not best_pos.nil?
      moves+=Bot.build_moves(map, map.curr_piece,start,best_pos)
    else
      moves+=["no_moves"]
    end

    moves.join(',')

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

  def self.set_piece(map, curr_piece, pos, need_clean=true)


    map.repl4

    rr = map.rr
    ff = map.field
    gg = map.gaps

    i = pos[0][0]
    h = pos[0][1]+1
    orient = pos[1]

    return [] if h>20

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
    map.clean_lines if need_clean

  end

end
