
require_relative  'helper'

class BlackBox

  def self.process_piece(map, curr_piece, next_piece)
    poss_with_diff = BlackBox.anlz(map, curr_piece, next_piece)

    best_pos_info = poss_with_diff.sort_by{|v| v[:diff]}.first
    best_pos = best_pos_info[:cpos]
  end

  def self.anlz(map, curr_piece, next_piece, show_all=false)


    diff_result=[]

    curr_poss=get_all_pos(map.rr, curr_piece)
    #sort
    curr_poss.sort_by!{|v| v[2]} unless  curr_poss.nil?

    curr_poss.each do |cpos|

      ####clone
      clone0_rr = map.rr.clone
      clone0_gg = map.gaps.clone

      #set piece
      Bot.set_piece(map, curr_piece, cpos)

      next_poss=get_all_pos(map.rr, next_piece)

      #sort positions
      next_poss.sort_by!{|v| v[2]} unless  next_poss.nil?

      next_poss.each do |npos|

        clone1_rr = map.rr.clone
        clone1_gg = map.gaps.clone

        Bot.set_piece(map, next_piece, npos)

        diff=find_diff(map)
        rr = map.rr.drop(1)
        diff_result<<{ cpos:cpos, npos:npos, diff_info:"min:#{rr.min} max:#{rr.max}",  diff:diff}

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
    when 'I'; anlz_I(rr)
    when 'J'; anlz_J(rr)
    when 'L'; anlz_L(rr)
    when 'O'; anlz_O(rr)
    when 'S'; anlz_S(rr)
    when 'Z'; anlz_Z(rr)
    when 'T'; anlz_T(rr)
    end

  end

  def self.fit_tmpl(i,templ, rr)
    rr_size = rr.size-1
    templ = templ.split(' ')
    return false if templ[0] =='w' && i!=1
    return false if templ[-1] =='w' && i+templ.size!=rr.size+1

    templ.select!{|x| x!='w'}

    marks = templ.map { |ss|  ss[0]  }
    hh = templ.map { |ss|  ss.sub('d','').sub('u','').to_i  }
    base_pos = marks.index('0')

    #p "info: marks=#{marks} hh=#{hh} base_pos=#{base_pos}"

    found_wrong = []
    curr= rr[i+base_pos]

    return false if i+templ.select{|x| x!='w'}.size>rr.size

    for k in 0..templ.size-1
      ik= i+k

      if ik>rr.size-1
        break
      end
      begin
        found_wrong<<[ik,'+'] if marks[k]=='+' && rr[ik]-hh[k]!=curr
        found_wrong<<[ik,'-'] if marks[k]=='-' && rr[ik]-hh[k]!=curr
        found_wrong<<[ik,'d'] if marks[k]=='d' && rr[ik]+hh[k]>curr
        found_wrong<<[ik,'u'] if marks[k]=='u' && rr[ik]-hh[k]<curr
        found_wrong<<[ik,'0'] if marks[k]=='0' && rr[ik]!=curr
      rescue
        #p "i=#{i} found=#{found_wrong}"
      end
    end

    #p "result: found correct subtemplate i:#{i} sub:#{rr[i..i+templ.size-1]}" if !found_wrong
    #p "#{templ}" if i ==9
    return found_wrong.empty?

  end

  #############analize each piece
  def self.anlz_I(rr)
    res=[]
    for i in 1..rr.size-1
      res<< [i+1,1, rr[i+1]+2, "u2 0 u2"]  if fit_tmpl(i,"u2 0 u2"  , rr)
      res<< [i,1, rr[i]+4,    "0 u2"]    if fit_tmpl(i,"0 u2"   , rr)
      res<< [i+1,1, rr[i+1]+4, "u2 0"]     if fit_tmpl(i,"u2 0"   , rr)
      res<< [i,1, rr[i]+2,    "w 0 u2"]  if fit_tmpl(i,"w 0 u2"   , rr)
      res<< [i+1,1, rr[i+1]+2, "u1 0 w"]   if fit_tmpl(i,"u2 0 w"   , rr)
      res<< [i,1, rr[i]+2, "0 w"]     if fit_tmpl(i,"0 w", rr)
      res<< [i,1, rr[i]+2, "w 0"]     if fit_tmpl(i,"w 0", rr)

      res<< [i,0,   rr[i], "0 0 0 0 w"]     if fit_tmpl(i, "0 0 0 0 w" , rr)
      res<< [i,0,   rr[i], "w 0 0 0 0"]     if fit_tmpl(i, "w 0 0 0 0" , rr)
      res<< [i,0,   rr[i]+2, "0 0 0 0"]     if fit_tmpl(i, "0 0 0 0"  , rr)
      res<< [i,0,   rr[i]+1, "0 0 0 0 u1"]  if fit_tmpl(i, "0 0 0 0 u1" , rr)
      res<< [i+1,0, rr[i+1]+1, "u1 0 0 0 0"] if fit_tmpl(i,"u1 0 0 0 0" , rr)
    end
    res
  end

  def self.anlz_J(rr)
    res=[]
    for i in 1..rr.size-1
      #0
      #  #
      #  ###
      res<< [i,0, rr[i]+2, "0 0 0"]       if fit_tmpl(i,"0 0 0" , rr)
      res<< [i+1,0, rr[i+1]+2, "u1 0 0 0"]    if fit_tmpl(i, "u1 0 0 0" , rr)

      #1  #
      #   #
      #  ##
      res<< [i,1, rr[i+1]+3, "0 0 u2"]      if fit_tmpl(i,"0 0 u2" , rr)
      res<< [i+1,1, rr[i+2]+3,"u2 d1 0 u2"]   if fit_tmpl(i, "u2 d1 0 u2", rr)

      #2
      #  ###
      #    #
      res<< [i,2, rr[i]+1,    "+1 +1 0 +1"]   if fit_tmpl(i,"+1 +1 0 +1", rr)
      res<< [i,2, rr[i],    "+1 +1 0 u1"]   if fit_tmpl(i,"+1 +1 0 u2", rr)
      res<< [i,2, rr[i]+1,    "0 0 -1"]     if fit_tmpl(i,"0 0 -1", rr)
      res<< [i,2, rr[i]+1+1,  "0 0 d2"]     if fit_tmpl(i,"0 0 d2", rr) #added +1 because of gap
      res<< [i,2, rr[i+1]+1+1,"-1 0 -1"]      if fit_tmpl(i,"-1 0 -1" , rr) #added +1 because of gap

      #3 ##
      #  #
      #  #
      res<< [i,3, rr[i]+3,"0 +2"]         if fit_tmpl(i,"0 +2", rr)
      res<< [i+1,3, rr[i+1],"u1 0 u3"]        if fit_tmpl(i,"u1 0 u3", rr)
      res<< [i+1,3, rr[i+2]+1, "u1 d2 0 u1"]    if fit_tmpl(i,"u1 d2 0 u1", rr)
    end
    res
  end

  def self.anlz_L(rr )
    res=[]
    for i in 1..rr.size-1
      #0   #
      #  ###

      res<< [i,0, rr[i]+2,"0 0 0"]  if fit_tmpl(i,"0 0 0", rr)
      res<< [i,0, rr[i]+2,"0 0 0 u1"]  if fit_tmpl(i,"0 0 0 u1", rr)

      #1 ##
      #   #
      #   #
      res<< [i,1, rr[i+1]+3,"+2 0"]     if fit_tmpl(i,"+2 0", rr)
      res<< [i,1, rr[i],"u3 0 u1"]    if fit_tmpl(i,"u3 0 u1", rr)
      res<< [i+1,1, rr[i+1]+1,"u1 0 d2"]    if fit_tmpl(i,"u1 0 d2", rr)

      #2
      #  ###
      #  #
      res<< [i+1,2, rr[i+1]+1,  "u1 0 +1 +1"]   if fit_tmpl(i,"u1 0 +1 +1", rr)
      res<< [i,2, rr[i+1]+1, "-1 0 0"]      if fit_tmpl(i,"-1 0 0", rr)
      res<< [i,2, rr[i+1]+1+1,"d2 0 0"]     if fit_tmpl(i,"d2 0 0" , rr) #added +1 because of gap
      res<< [i,2, rr[i+1]+1+1,"-1 0 -1"]      if fit_tmpl(i,"-1 0 -1", rr) #added +1 because of gap

      #3  #
      #   #
      #   ##
      res<< [i+1,3, rr[i+1]+1,  "u2 0 0"]  if fit_tmpl(i,"u2 0 0" , rr)
      res<< [i, 3,  rr[i]+3,  "w 0 0"]      if fit_tmpl(i,"w 0 0" , rr)
      res<< [i+1,3, rr[i+1]+3,  "u2 0 -1"]  if fit_tmpl(i,"u2 0 -1" , rr)

    end
    res
  end


  def self.anlz_O(rr)
    res=[]
    for i in 1..rr.size-1
      res<< [i+1,0, rr[i+1]+2,"u1 0 0" ]  if fit_tmpl(i,"u1 0 0", rr)
      res<< [i,0, rr[i]+2,"0 0 u1"]     if fit_tmpl(i,"0 0 u1" , rr)
      res<< [i,0, rr[i]+1,"w 0 0"]      if fit_tmpl(i,"w 0 0" , rr)
      res<< [i,0, rr[i]+2, "0 0 w"]     if fit_tmpl(i,"0 0 w", rr)
      res<< [i,0, rr[i]+2, "0 0"]     if fit_tmpl(i,"0 0", rr)
      res<< [i,0, rr[i+1]+2+1, "d1 0"]    if fit_tmpl(i,"d1 0", rr) # gap
      res<< [i,0, rr[i]+2+1, "0 d1"]      if fit_tmpl(i,"0 d1", rr)   # gap
    end
    res
  end


  #########
  def self.anlz_S(rr)
    res=[]
    for i in 1..rr.size-1

      res<< [i,0, rr[i+2]+1, "0 0 +1"]    if fit_tmpl(i,"0 0 +1", rr)
      res<< [i,0, rr[i+2]+1+1,"d1 d1 0"]    if fit_tmpl(i,"d1 d1 0", rr) #added +1 because of gap
      res<< [i,0, rr[i+2]+4, "0 0 0"]     if fit_tmpl(i,"0 0 0", rr) #added +1 because of gap
      res<< [i,1, rr[i]+2, "+1 0"]      if fit_tmpl(i,"+1 0", rr)
      res<< [i,1, rr[i]+2, "w 0 d1 u2"]   if fit_tmpl(i,"w 0 d1 u2", rr)
      res<< [i+1,1, rr[i+1]+2, "u1 0 d1 u2"]  if fit_tmpl(i,"u1 0 d1 u2", rr)
    end

    res
  end

  def self.anlz_Z(rr)
    res=[]
    for i in 1..rr.size-1
      res<< [i,0, rr[i]+1, "+1 0 0"]    if fit_tmpl(i,"+1 0 0", rr)
      res<< [i,0, rr[i]+1+1, "0 -1 d1"] if fit_tmpl(i,"0 -1 d1", rr) #gap
      res<< [i,0, rr[i]+4, "0 0 0"]   if fit_tmpl(i,"0 0 0", rr)
      res<< [i,1, rr[i]+3, "0 +1"]    if fit_tmpl(i,"0 +1" , rr)
      res<< [i+1,1, rr[i+1]+2, "+1 0 +1"]   if fit_tmpl(i,"+1 0 +1" , rr)
      res<< [i,1, rr[i]+3, "0 +1 u2"]   if fit_tmpl(i,"0 +1 u2", rr)
      res<< [i,1, rr[i]+3, "w 0 +1 u2"] if fit_tmpl(i,"w 0 +1 u2" , rr)
      res<< [i,1, rr[i]+2, "0 +1 w"]  if fit_tmpl(i,"0 +1 w" , rr)
    end
    res
  end

  ###########
  def self.anlz_T(rr)
    res=[]
    for i in 1..rr.size-1
      res<< [i, 0, rr[i+1]+2, "0 0 0"]        if fit_tmpl(i,"0 0 0" , rr)
      res<< [i, 0, rr[i+1]+2+1, "-1 0 0"]       if fit_tmpl(i,"-1 0 0" , rr) #gap
      res<< [i, 0, rr[i+1]+2+1, "0 0 -1"]       if fit_tmpl(i,"0 0 -1" , rr) #gap

      res<< [i+1,1, rr[i+2]+3,    "u2 +1 0"]    if fit_tmpl(i,"u2 +1 0 " , rr)
      res<< [i,  1, rr[i+1]+2,    "+1 0 u1"]    if fit_tmpl(i,"+1 0 u2" , rr)
      res<< [i+1,1, rr[i+1]+2+1,  "u1 0 d2"]    if fit_tmpl(i,"u1 0 d2" , rr) #gap
      res<< [i,  1, rr[i+1]+3,    "+1 0 w"]     if fit_tmpl(i,"+1 0 w" , rr)
      res<< [i,  1, rr[i]+2,    "w 0 d1 u1"]    if fit_tmpl(i,"w 0 d1 u1" , rr)
      res<< [i,1,   rr[i]+1,    "u1 0 w"]     if fit_tmpl(i,"u1 0 w"  , rr)

      res<< [i,  2, rr[i],  "+1 0 +1"]        if fit_tmpl(i,"+1 0 +1" , rr)
      res<< [i,  2, rr[i]+1,  "0 d2 0"]       if fit_tmpl(i,"0 d2 0" , rr)

      res<< [i+1,3, rr[i+1]+3,  "u1 0 +1"]      if fit_tmpl(i,"u1 0 +1"   , rr)
      res<< [i,  3, rr[i+1]+2,  "-1 0 u1"]      if fit_tmpl(i,"-1 0 u1" , rr)
      res<< [i,  3, rr[i+1]+2+1,"d2 0 u1"]      if fit_tmpl(i,"d2 0 u1" , rr)
      res<< [i+1,3, rr[i+2]+2,  "u1 d1 0 w"]      if fit_tmpl(i,"u1 d1 0 w" , rr)
      res<< [i,  3, rr[i+1]+2,  "w 0 u1"]       if fit_tmpl(i,"w 0 u1"  , rr)
    end
    res
  end



end
