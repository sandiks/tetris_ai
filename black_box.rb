
require_relative  'helper'
require_relative  'bb_logic'

class BlackBox

  def self.process_piece(map, curr_piece, next_piece)
    poss_with_diff = BlackBox.anlz(map, curr_piece, next_piece)

    best_pos_info = poss_with_diff.sort_by{|v| v[:sum]}.first
    best_pos = best_pos_info[:cpos]
  end

  def self.anlz(map, curr_piece, next_piece, show_all=false)


    diff_result=[]

    curr_poss=get_all_pos(map.rr, curr_piece)

    #sort
    curr_poss.sort_by!{|v| v[2]} unless  curr_poss.nil?

    p curr_poss if show_all

    curr_poss.each do |cpos|

      ####clone
      clone0_rr = map.rr.clone
      clone0_gg = map.gaps.clone

      curr_factor = cpos[2]
      gap_min = BBGaps.gap_belows(map,curr_piece,cpos)
      #curr_factor += 5-gap_min>0 ? 5-gap_min : 0

      #set curr piece
      Bot.set_piece(map, curr_piece, cpos)

      #find next positions
      next_poss=get_all_pos(map.rr, next_piece)

      #sort positions
      next_poss.sort_by!{|v| v[2]} unless  next_poss.nil?

      next_poss.each do |npos|

        clone1_rr = map.rr.clone
        clone1_gg = map.gaps.clone

        nextp_factor = npos[2]

        Bot.set_piece(map, next_piece, npos)

        #diff=find_diff(map)
        sum = curr_factor+nextp_factor

        rr = map.rr.drop(1)
        diff_result<<{ cpos:cpos, npos:npos, diff_info:"curr factor:#{curr_factor} next factor:#{nextp_factor}",  sum:sum}

        #restore
        map.rr = clone1_rr
        map.gaps = clone1_gg

      end

      map.rr = clone0_rr
      map.gaps = clone0_gg

    end

    diff_result
    #find_min_level(found)

  end


  def self.find_diff(map)
    rr = map.rr.drop(1)
    rr.max-rr.min
  end

  def self.get_all_pos(rr, curr_piece)

    curr_found =  case curr_piece
    when 'I'; BBLogic.anlz_I(rr)
    when 'J'; BBLogic.anlz_J(rr)
    when 'L'; BBLogic.anlz_L(rr)
    when 'O'; BBLogic.anlz_O(rr)
    when 'S'; BBLogic.anlz_S(rr)
    when 'Z'; BBLogic.anlz_Z(rr)
    when 'T'; BBLogic.anlz_T(rr)
    end

  end
end
