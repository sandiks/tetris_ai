require_relative  'helper'

class Bot

  def self.make_movies(gg)

    start = gg.this_piece_position
    curr_piece= gg.this_piece_type
    next_piece= gg.next_piece_type


    map = gg.map
    map.parse_from(gg.my.field)

    best_pos = BlackBox.process_piece(map, curr_piece,next_piece)

    if not best_pos.nil?
      Bot.get_turnes(curr_piece,start,best_pos)
    else
      ["no_moves"]
    end

  end

  def self.make_test_turn(map, curr_p, next_p)

    poss_with_diff = BlackBox.anlz(map, curr_p, next_p)

    best_pos_info = poss_with_diff.sort_by{|v| v[:diff]}.first
    best_pos = best_pos_info[:cpos]

    p "curr=#{curr_p} next=#{next_p} best_pos=#{best_pos} info: #{best_pos_info}"

    Bot.set_piece(map, curr_p, best_pos)
    #p Bot.get_turnes(curr_p,[3,-1],best_pos)

  end

  def self.get_turnes(ptype, start, pos)

    turnes = calc_turnes(ptype, pos[1])
    start[0]+=turnes[:shift_x]
    #start[1]-=turnes[:shift_y]

    dif_x =  pos[0]-start[0]-1
    moves_x =   dif_x<0 ? ['left']*(dif_x*-1) : ['right']*(dif_x)

    moves = turnes[:turnes]+moves_x+["drop"]

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
      when 1; r0+=1; r1+=3;
      when 2;
        if BlackBox.fit_tmpl(i,"0 0 d2" , rr); r0+=1; r1=r0; r2=r1; gg[i+2]=r2-2; end
        if BlackBox.fit_tmpl(i,"0 0 -1" , rr); r0+=1; r1=r0; r2=r1;  end
        if BlackBox.fit_tmpl(i,"-1 0 -1" , rr); r1+=1; r0=r1; r2=r1; gg[i]=r0-1; end
      when 3; r0+=3; r1+=1;
      end

    when 'L'
      case orient
      when 0; r0+=1;r1+=1;r2+=2;
      when 1; r0+=1;r1=r0;
      when 2; r1+=1;r0=r1;r2=r1
      when 3; r0+=3;r1+=1;
      end

    when 'O'; r0+=2;r1+=2;

    when 'S'
      case orient
      when 0;
        if BlackBox.fit_tmpl(i,"0 0 0" , rr); r0+=1; r1+=2; r2+=2; gg[i+2]=r2-1; end
        if BlackBox.fit_tmpl(i,"d1 d1 0" , rr); gg[i]=r2-1 if r0<r2-1 ; r0=r2;  r1=r2+1; r2+=1; end

      when 1;
        if BlackBox.fit_tmpl(i,"0 0" , rr); gg[i]=r0+1; r0+=3; r1+=2;  end
        if BlackBox.fit_tmpl(i,"+1 0" , rr); r0+=2; r1+=2;  end
      end

    when 'Z'
      case orient

      when 0;
        if BlackBox.fit_tmpl(i,"0 0 0" , rr); gg[i]=r0+1; r0+=2; r1+=2; r2=+1;  end
        if BlackBox.fit_tmpl(i,"0 d1 d1" , rr); r0+=1; r1=r0-1; r2=r0-1; end

      when 1;
        if BlackBox.fit_tmpl(i,"0 0" , rr); gg[i+1]=r1+1; r0+=2; r1+=3;  end
        if BlackBox.fit_tmpl(i,"+1 0" , rr); r0+=2; r1+=2;  end

      end
    when 'T'
      case orient
      when 0;
        if BlackBox.fit_tmpl(i, "0 0 0" , rr); r0+=1;r1+=2;r2+=1;  end
        if BlackBox.fit_tmpl(i, "d1 0 0" , rr); r1+=2;r2+=1;r0=r2; end
        if BlackBox.fit_tmpl(i, "0 0 d1" , rr); r1+=2;r0+=1;r2=r0; end

      when 1; r0+=1;r1+=3;
      when 2; r0+=1;r1+=2;r2+=1;
      when 3; r0+=3;r1+=1;
      end

    end

    rr[i],rr[i+1],rr[i+2] = r0,r1,r2 if i<=map.w-2
    rr[i],rr[i+1] = r0,r1 if i<= map.w-1
    rr[i] = r0 if i== map.w


  end



end
