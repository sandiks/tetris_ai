
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

  def self.anlz(map, show_all=false)

    curr_piece = map.curr_piece
    next_piece = map.next_piece

    diff_result=[]

    curr_poss=get_all_pos(map.rr, curr_piece)
    #sort
    curr_poss.sort_by!{|v| v[2]} unless  curr_poss.nil?

    #curr_poss.each { |e| p e  }	 if show_all
    curr_poss.each do |cpos|

      ####clone
      clone0_ff = map.clone_field

      curr_factor = cpos[2]+cpos[4]

      gap_min = BBGaps.gap_belows(map,curr_piece,cpos)


      removed0 = Bot.set_piece(map, curr_piece, cpos)
      curr_factor = curr_factor - removed0.size + gap_min 

      p "cpos=#{cpos} factor=#{curr_factor}"  if show_all

      next_poss=get_all_pos(map.rr, next_piece)
      next_poss.sort_by!{|v| v[2]} unless  next_poss.nil?

      next_poss.each do |npos|
        ###clone2
        clone1_ff = map.clone_field
        next_factor = npos[2]+npos[4]


        gap_min1 = BBGaps.gap_belows(map,next_piece,npos)
        removed1=Bot.set_piece(map, next_piece, npos)
        
        next_factor =next_factor-removed1.size+gap_min1 

        #diff=find_diff(map)
        sum = curr_factor+next_factor
        diff_result<<{ cpos:cpos, npos:npos, factors:"level0-level1: #{curr_factor}-#{next_factor}",  sum:sum}

        #restore
        map.restore_field(clone1_ff)

    end
    map.restore_field(clone0_ff)

  end
  diff_result
  #find_min_level(found)

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

def self.find_diff(map)
  rr = map.rr.drop(1)
  rr.max-rr.min
end

end
