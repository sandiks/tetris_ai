
require_relative  'helper'

class BBGaps

  def self.process_gaps(map,start)
    curr_p = map.curr_piece

    res = check_gaps(map, curr_p).first

    if not res.nil?
      pos = [[res[:pos],res[:level]], res[:orient]]

      moves = Bot.build_moves(map, curr_p, start, pos,false)
      moves+= [res[:moves]]

      #set piece

      if res[:moves]=='left' ; pos[0][0]-=1; else pos[0][0]+=1; end
      Bot.set_piece(map, curr_p, pos)
      #BBGaps.do_shift_piece(map, curr_p, pos, res[:moves])

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
    rm1 , r1 = rr[i-1], rr[i+1]

    same_level_right = gg[i]-1==rr[i+1]
    same_level_left = gg[i]-1==rr[i-1]
    case curr_p

    when 'I'
      res << {pos:i+1, level:r1, orient:0, moves:"left"} if BBLogic.fit_tmpl(i+1,"0 0 0 0" , rr) && same_level_right && i<7
      res << {pos:i-4, level:rm1, orient:0, moves:"right"} if BBLogic.fit_tmpl(i-4,"0 0 0 0" , rr) && same_level_left && i>4

    when 'J'
      res << {pos:i-3, level:rm1, orient:0, moves:"right"} if BBLogic.fit_tmpl(i-3,"0 0 0" , rr) && same_level_left && i>3
      res << {pos:i+1, level:r1, orient:1, moves:"left"} if BBLogic.fit_tmpl(i+1,"0 0" , rr) && same_level_right && i<9
    when 'L'
      res << {pos:i-2, level:rm1, orient:3, moves:"right"} if BBLogic.fit_tmpl(i-2,"0 0" , rr) && same_level_left && i>4
      res << {pos:i+1, level:r1, orient:0, moves:"left"} if BBLogic.fit_tmpl(i+1,"0 0 0" , rr) && same_level_right && i<8

    when 'T'
      res << {pos:i-3, level:rm1, orient:0, moves:"right"} if BBLogic.fit_tmpl(i-3,"0 0 0" , rr) && same_level_left && i>4
      res << {pos:i+1, level:r1, orient:0, moves:"left"} if BBLogic.fit_tmpl(i+1,"0 0 0" , rr) && same_level_right && i<8
    when 'Z'
      res << {pos:i-3, level:rm1, orient:0, moves:"right"} if BBLogic.fit_tmpl(i-3,"0 0 0" , rr) && same_level_left && i>4
    when 'S'
      res << {pos:i+1, level:r1, orient:0, moves:"left"} if BBLogic.fit_tmpl(i+1,"0 0 0" , rr) && same_level_right && i<8

    end
    res
  end


  def self.gap_belows(map,curr_piece, pos)
    rr = map.rr
    gg = map.gaps

    i = pos[0][0]
    orient = pos[1]

    templ = case [curr_piece,orient]
    when ['I',0]; "1 1 1 1"
    when ['I',1]; "1"

    when ['O',0]; "2 2"

    when ['J',0]; "2 1 1"
    when ['J',1]; "1 3"
    when ['J',2]; "1 1 2"
    when ['J',3]; "3 1"

    when ['L',0]; "1 1 2"
    when ['L',1]; "1 3"
    when ['L',2]; "2 1 1"
    when ['L',3]; "3 1"

    when ['Z',0]; "1 2 1"
    when ['Z',1]; "2 2"

    when ['S',0]; "1 2 1"
    when ['S',1]; "2 2"

    when ['T',0]; "1 2 1"
    when ['T',1]; "1 3"
    when ['T',2]; "1 2 1"
    when ['T',3]; "3 1"
    end

    tt = templ.split(' ')
    r = tt.size
    res=[]

    for j in i..i+r-1
      added = tt[j-i].to_i
     
      if gg[j]>0

        diff=3-(rr[j]-gg[j])
        diff=0 if diff<0
        res<<diff+added
      end
    end


    min =res.min
    min.nil? ? 0 : min/2

  end
end
