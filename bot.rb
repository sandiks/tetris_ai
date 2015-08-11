require_relative  'helper'

class Bot

  def self.make_movies(gg)

    start = gg.this_piece_position
    ptype= gg.this_piece_type

    map = gg.map
    map.parse_from(gg.my.field)

    best_pos = BlackBox.anlz(map, ptype)
    #best_pos = all_pos.first if best_pos.nil?
    if not best_pos.nil?
      Bot.get_turnes(ptype,start,best_pos)
    else
      ["no_moves"]
    end

  end

  def self.get_turnes(ptype, start, pos)

    turnes = calc_turnes(ptype, pos[3])
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
    orient = pos[3]

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
      when 2; r0+=1; r1+=1; r2+=2;
      when 3; r0+=1; r1+=3;
      end

    when 'L'
      case orient
      when 0; r0+=1;r1+=1;r2+=2;
      when 1; r0+=1;r1+=3;
      when 2; r0+=2;r1+=1;r2+=1;
      when 3; r0+=3;r1+=1;
      end

    when 'O'; r0+=2;r1+=2;

    when 'S'
      case orient
      when 0;
        gg[i+2]=r2+1 if r1==r2
        r0+=1;r1+=2;r2=r1;

      when 1; r0+=2;r1+=2;
      end

    when 'Z'
      case orient
      when 0; r1+=2; r0=r1; r2+=1;
      when 1; r0+=2;r1+=2;
      end


    when 'T'
      case orient
      when 0; r0+=1;r1+=2;r2+=1;
      when 1; r0+=1;r1+=3;
      when 2; r0+=1;r1+=2;r2+=1;
      when 3; r0+=3;r1+=1;
      end

    end

    rr[i],rr[i+1],rr[i+2] = r0,r1,r2 if i<map.w-2
    rr[i],rr[i+1] = r0,r1 if i== map.w-1
    rr[i] = r0 if i== map.w


  end



end
