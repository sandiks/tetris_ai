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

  def self.make_test_turn(map, curr_p, next_p)

    start = [3,-1]
    moves = []

    res = BBGaps.process_gaps(map,start,curr_p)
    p "gaps #{res}"
    if not res.nil?
      moves+=res
      return moves.join(',')
    end


    poss_with_diff = BlackBox.anlz(map, curr_p, next_p,true)

    best_pos_info = poss_with_diff.sort_by{|v| v[:sum]}.first
    best_pos = best_pos_info[:cpos]

    p "curr=#{curr_p} next=#{next_p} info: #{best_pos_info}"

    Bot.set_piece(map, curr_p, best_pos)
    #p Bot.get_turnes(curr_p,[3,-1],best_pos)

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

  def self.set_piece(map, p_type, pos)

    rr = map.rr
    gg = map.gaps

    if pos.nil?

      return
    end

    i = pos[0]
    orient = pos[1]

    r0,r1,r2 = rr[i],rr[i+1],rr[i+2]


    case p_type

    when 'I'
      case orient
      when 0; r0+=1;r1+=1;r2+=1;rr[i+3]+=1;
      when 1; r0+=4
      end

    when 'J'
      case orient
      when 0; r0+=2; r1+=1; r2+=1;
      when 1;
        if BBLogic.fit_tmpl(i,"0 0" , rr); r0+=1; r1+=3;  end
        if BBLogic.fit_tmpl(i,"d1 0" , rr); r0=r1+1; r1+=3; gg[i]=r0-1 if rr[i]<r0;  end

      when 2;
        if BBLogic.fit_tmpl(i,"0 0 d1" , rr); r0+=1; r1=r0; r2=r1; gg[i+2]=r2-2 if rr[i+2]<r0-2; end
        if BBLogic.fit_tmpl(i,"-1 0 -1" , rr); r1+=1; r0=r1; r2=r1; gg[i]=r0-1; end
      when 3; r1+=1; r0=r1
      end

    when 'L'
      case orient
      when 0; r0+=1;r1+=1;r2+=2;
      when 1; r0+=1;r1=r0; gg[i+1]=r1-3 if rr[i+1]<r1-3;
      when 2;
        if BBLogic.fit_tmpl(i,"d1 0 0" , rr); r2+=1; r1=r2; r0=r2; gg[i]=r2-2 if rr[i]<r2-2; end
        if BBLogic.fit_tmpl(i,"-1 0 -1" , rr); r1+=1; r0=r1; r2=r1; gg[i+2]=r0-1; end

      when 3;
        if BBLogic.fit_tmpl(i,"0 0" , rr); r0+=3; r1+=1;  end
        if BBLogic.fit_tmpl(i,"0 d1" , rr); r0+=3; r1=r0-2; gg[i+1]=r1-1 if rr[i+1]<r1-1; end

      end

    when 'O';
      if BBLogic.fit_tmpl(i,"0 0" , rr); r0+=2; r1=r0;  end
      if BBLogic.fit_tmpl(i,"0 d1" , rr); r0+=2; r1=r0; gg[i+1]=r1-2; end
      if BBLogic.fit_tmpl(i,"d1 0" , rr); r1+=2; r0=r1; gg[i]=r1-2; end

    when 'S'
      case orient
      when 0;
        if BBLogic.fit_tmpl(i,"0 0 0" , rr); r0+=1; r1+=2; r2+=2; gg[i+2]=r2-1; end
        if BBLogic.fit_tmpl(i,"d1 d1 0" , rr); gg[i]=r2-1 if r0<r2-1 ; r0=r2;  r1=r2+1; r2+=1; end

      when 1;
        if BBLogic.fit_tmpl(i,"0 0" , rr); gg[i]=r0+1; r0+=3; r1+=2;  end
        if BBLogic.fit_tmpl(i,"u1 0" , rr); r0+=2; r1=r0-1; gg[i+1]=r1-2 if rr[i+1]<r1-2;  end
      end

    when 'Z'
      case orient

      when 0;
        if BBLogic.fit_tmpl(i,"0 0 0" , rr); gg[i]=r0+1; r0+=2; r1+=2; r2+=1;  end
        if BBLogic.fit_tmpl(i,"0 d1 d1" , rr); r0+=1; r1=r0; r2=r0-1; gg[i+1]=r1-2 if rr[i+1]<r1-2; gg[i+2]=r2-1 if rr[i+2]<r2-1; end

      when 1;
        if BBLogic.fit_tmpl(i,"0 0" , rr); gg[i+1]=r1+1; r0+=2; r1+=3;  end
        if BBLogic.fit_tmpl(i,"0 u1" , rr); r1+=2; r0=r1-1; gg[i]=r0-2 if rr[i]<r0-2;  end
      end

    when 'T'
      case orient

      when 0;
        if BBLogic.fit_tmpl(i, "0 0 0" , rr); r0+=1;r1+=2;r2+=1;  end
        if BBLogic.fit_tmpl(i, "d1 0 0" , rr); r1+=2;r2+=1;r0=r2; end
        if BBLogic.fit_tmpl(i, "0 0 d1" , rr); r1+=2;r0+=1;r2=r0; end

      when 1; if BBLogic.fit_tmpl(i, "0 d1" , rr); r0+=1; r1=r0+1;  gg[i+1]=r1-3 if rr[i+1]<r1-3; end
      when 2; if BBLogic.fit_tmpl(i, "0 d1 0" , rr); r0+=1; r1=r0;r2=r0; end
      when 3; if BBLogic.fit_tmpl(i, "d1 0" , rr); r1+=1;r0=r1+1; gg[i]=r0-3 if rr[i]<r0-3; end
      end

    end

    rr[i],rr[i+1],rr[i+2] = r0,r1,r2 if i<=map.w-2
    rr[i],rr[i+1] = r0,r1 if i<= map.w-1
    rr[i] = r0 if i== map.w


  end

 

end
