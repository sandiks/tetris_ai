
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

    p curr_poss if show_all


    #p "clone0=#{clone0_rr}"


    curr_poss.each do |cpos|

      ####clone
      clone0_ff = map.field.clone

      curr_factor = cpos[2]
      #gap_min = BBGaps.gap_belows(map,curr_piece,cpos)
      #curr_factor += 5-gap_min>0 ? 5-gap_min : 0

      BlackBox.set_piece(map, curr_piece, cpos)
      next_poss=get_all_pos(map.rr, next_piece)
      next_poss.sort_by!{|v| v[2]} unless  next_poss.nil?

      next_poss.each do |npos|
        ###clone2

        clone1_ff = map.field.clone
        nextp_factor = npos[2]

        BlackBox.set_piece(map, next_piece, npos)
        #p "clone0_rr=#{clone0_rr} clone1=#{clone1_rr} pos0=#cpos pos1=#{npos}"


        #diff=find_diff(map)
        sum = curr_factor+nextp_factor
        diff_result<<{ cpos:cpos, npos:npos, diff_info:"curr factor:#{curr_factor} next factor:#{nextp_factor}",  sum:sum}

        #restore

        map.field= clone1_ff

      end
      map.field= clone0_ff
      #p "restore clone0_rr=#{clone0_rr} gg=#{clone0_gg} pos0=#{cpos}"

    end
    #p "restore map.rr=#{map.rr} gg=#{map.gaps}"

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

  end

  def self.set_piece_rr(map, curr_piece, pos)

    rr = map.rr
    gg = map.gaps

    if pos.nil?

      return
    end

    i = pos[0][0]
    orient = pos[1]

    r0,r1,r2 = rr[i],rr[i+1],rr[i+2]


    case curr_piece

    when 'I'
      case orient
      when 0; r0=r1=r2=r0+1;rr[i+3]+=1;
      when 1; r0+=4
      end

    when 'J'
      case orient
      when 0; r0+=2; r1+=1; r2+=1;
      when 1;
        if BBLogic.fit_tmpl(i,"0 0" , rr); r0+=1; r1+=3;  end
        if BBLogic.fit_tmpl(i,"d1 0" , rr); r0=r1+1; r1+=3; gg[i]=r0-1 if rr[i]<r0;  end

      when 2;
        if BBLogic.fit_tmpl(i,"0 0 d1" , rr); r0=r1=r2= r0+1; gg[i+2]=r2-2 if rr[i+2]<r0-2; end
        if BBLogic.fit_tmpl(i,"-1 0 -1" , rr); r0=r1=r2= r1+1; gg[i]=r0-1; end
      when 3; r0=r1=r1+1;
      end

    when 'L'
      case orient
      when 0; r0+=1;r1+=1;r2+=2;
      when 1; r0=r1=r0+1;gg[i+1]=r1-3 if rr[i+1]<r1-3;
      when 2;
        if BBLogic.fit_tmpl(i,"d1 0 0" , rr); r0=r1=r2=r1+1; gg[i]=r2-2 if rr[i]<r2-2; end
        if BBLogic.fit_tmpl(i,"-1 0 -1" , rr); r0=r1=r2=r1+1; gg[i+2]=r0-1; end

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
        if BBLogic.fit_tmpl(i,"d1 d1 0" , rr); r2+=1; r0=r2-1;r1=r2; gg[i]=r0-1 if rr[i]<r0-1; gg[i+1]=r1-2 if rr[i+1]<r1-2;  end

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
        if BBLogic.fit_tmpl(i, "d1 0 0" , rr); r1+=2;r2+=1;r0=r2; gg[i]=r0-1 if rr[i]<r0-1; end
        if BBLogic.fit_tmpl(i, "0 0 d1" , rr); r1+=2;r0+=1;r2=r0; gg[i+2]=r2-1 if rr[i+2]<r2-1; end

      when 1; if BBLogic.fit_tmpl(i, "0 d1" , rr); r0+=1; r1=r0+1;  gg[i+1]=r1-3 if rr[i+1]<r1-3; end
      when 2; if BBLogic.fit_tmpl(i, "0 d1 0" , rr); r0+=1; r1=r0;r2=r0; end
      when 3; if BBLogic.fit_tmpl(i, "d1 0" , rr); r1+=1;r0=r1+1; gg[i]=r0-3 if rr[i]<r0-3; end
      end

    end

    rr[i],rr[i+1],rr[i+2] = r0,r1,r2 if i<=map.w-2
    rr[i],rr[i+1] = r0,r1 if i<= map.w-1
    rr[i] = r0 if i== map.w


    #clean_lines(map)

    set_piece_for_field(map,curr_piece, pos)

  end
end
