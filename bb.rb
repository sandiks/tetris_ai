
require_relative  'helper'
require_relative  'bb_logic'

class BlackBox



  def self.anlz_simple(map, show_all=false)

    diff_result=[]

    curr_poss=get_all_pos(map.rr, map.curr_piece)

    #sort
    curr_poss.sort_by!{|v| v[2]} unless  curr_poss.nil?

    p curr_poss if show_all

    cpos = curr_poss.first
    curr_factor = cpos[2]
    nextp_factor = 0
    sum = curr_factor+nextp_factor

    diff_result<<{ cpos:cpos, npos:"nope", diff_info:"curr factor:#{curr_factor} next factor:#{nextp_factor}",  sum:sum}

  end

  def self.anlz(map)

    res=[]
    res = calc_for_curr(map,[map.curr_piece,map.next_piece],0)
    #res.min_by{|x| x[:sum]}

  end

  def self.calc_for_curr(map, pieces, level)

    result=[]
    curr_piece = pieces[level]

    curr_poss=get_all_pos(map.rr, curr_piece)


    curr_poss.sort_by!{|v| v[2]} unless  curr_poss.nil?

    curr_poss.each_with_index do |cpos,id1|

      ####clone
      clone0_ff = map.clone_field

      rem_lines=[]
      gaps_below = BBGaps.gap_belows(map,curr_piece,cpos)
      rem_lines = Bot.set_piece(map, curr_piece, cpos)

      curr_factor = cpos[2]+gaps_below
      curr_factor+= cpos[4]-rem_lines.size

      curr_result= {piece: curr_piece, pos:cpos, factor:curr_factor,gap:gaps_below,
                    removed:rem_lines.size, sum:curr_factor, next:nil, best_next:nil}

      if level <1
        res1=calc_for_curr(map , pieces , level+1)
        curr_result[:next] = res1
        curr_result[:best_next] = res1.min_by{|x| x[:sum]}
        curr_result[:sum] += curr_result[:best_next][:sum]
      end

      map.restore_field(clone0_ff)
      result<<curr_result

    end
    result

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
