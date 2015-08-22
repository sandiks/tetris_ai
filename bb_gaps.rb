
require_relative  'helper'

class BBGaps

  def self.process_gaps(map,start,curr_p)

    res = check_gaps(map, curr_p).first
    
    if not res.nil?
      pos = [res[:pos], res[:orient]]

      moves = Bot.build_moves(map, curr_p, start, pos,false)
      moves+= [res[:moves]]

      #set piece

      Bot.set_piece(map, curr_p, pos)
      BBGaps.do_shift_piece(map, curr_p, pos, res[:moves])

      moves
    else
      nil
    end
  end

  def self.check_gaps(map, currp)
    gg = map.gaps
    res=[]

    for i in 1..10
      if gg[i]!=0
        res += fix_gap(map, i, currp)
      end
    end

    res
  end

  def self.fix_gap(map, i, curr_p)
    res = []
    rr = map.rr
    gg = map.gaps

    same_level_right = gg[i]-1==rr[i+1]
    same_level_left = gg[i]-1==rr[i-1]
    case curr_p

    when 'I'
      res << {pos:i+1, orient:0, moves:"left"} if BBLogic.fit_tmpl(i+1,"0 0 0 0" , rr) && same_level_right && i<7
      res << {pos:i-4, orient:0, moves:"right"} if BBLogic.fit_tmpl(i-4,"0 0 0 0" , rr) && same_level_left && i>4

    when 'J'
      res << {pos:i-3, orient:0, moves:"right"} if BBLogic.fit_tmpl(i-3,"0 0 0" , rr) && same_level_left && i>3
      res << {pos:i+1, orient:1, moves:"left"} if BBLogic.fit_tmpl(i+1,"0 0" , rr) && same_level_right && i<9
    when 'L'
      res << {pos:i-2, orient:3, moves:"right"} if BBLogic.fit_tmpl(i-2,"0 0" , rr) && same_level_left && i>4
      res << {pos:i+1, orient:0, moves:"left"} if BBLogic.fit_tmpl(i+1,"0 0 0" , rr) && same_level_right && i<8

    when 'T'
      res << {pos:i-3, orient:0, moves:"right"} if BBLogic.fit_tmpl(i-3,"0 0 0" , rr) && same_level_left && i>4
      res << {pos:i+1, orient:0, moves:"left"} if BBLogic.fit_tmpl(i+1,"0 0 0" , rr) && same_level_right && i<8

    end
    res
  end

  def self.do_shift_piece(map, p_type, pos, move)

    rr = map.rr
    gg = map.gaps

    i = pos[0]
    orient = pos[1]
    r0,r1,r2,r3 = rr[i],rr[i+1],rr[i+2],rr[i+3]

    case p_type

    when 'I'
      case move
      when "left"; r0,r1,r2 = r1,r2,r3; r3-=1; gg[i-1] =0;
      when "right"; r1,r2,r3 = r0,r1,r2; r0-=1; gg[i+4] =0;
      end

    when 'J'
      case move
      when 'left'; r0,r1 = r1,r2; r2-=3; gg[i-1] =0;
      when 'right'; r1,r2 = r0,r1; r0-=2; gg[i+3] =0;
      end

    when 'L'
      case move
      when 'left'; r0,r1 = r1,r2; r2-=2; gg[i-1] =0;
      when 'right'; r1,r2 = r0,r1; r0-=3; gg[i+2] =0;
      end


    when 'T'
      case move
      when "left"; r0,r1 = r1,r2; r2-=1; gg[i-1] =0;
      when "right"; r1,r2 = r0,r1; r0-=1; gg[i+3] =0;
      end

    end

    rr[i],rr[i+1],rr[i+2],rr[i+3] = r0,r1,r2,r3
  end

  def self.gap_belows(map, curr_p, pos)
    rr = map.rr
    gg = map.gaps

    i = pos[0]
    orient = pos[1]

    case curr_p

    when 'I'
      case orient
      when 0; rr[i..i+3].min - gg[i..i+3].max
      when 1; rr[i]-gg[i]
      end
    when 'J','L','Z','S','T'
      case orient
      when 0,2; rr[i..i+2].min - gg[i..i+2].max
      when 1,3; rr[i..i+1].min - gg[i..i+1].max
      end
    when 'O'
      rr[i..i+1].min - gg[i..i+1].max

    end

  end
end
