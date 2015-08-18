require_relative  'bot'
require_relative  'helper'

class BlackBox

  def self.detect_position(map, ptype)


    #res = check_gaps(map, ptype)
    #return if not res.nil?

    all_pos = BlackBox.anlz(map, ptype)
    #Bot.set_piece(map, ptype, pos)

    find_max_compatibility(all_pos)

  end

  def self.anlz(map, piece_type)


    rr = map.rr #get top line
    gg = map.gaps

    max = rr.max
    min = rr[1..map.w].min

    res=[]


    found =  case piece_type
    when 'I'; anlz_I(rr)
    when 'J'; anlz_J(rr)
    when 'L'; anlz_L(rr)
    when 'O'; anlz_O(rr)
    when 'S'; anlz_S(rr)
    when 'Z'; anlz_Z(rr)
    when 'T'; anlz_T(rr)
    end

    #p found
    if found.nil?
      [1,0, 100]
    else
      find_min_level(found)
    end
  end

  def self.fit_tmpl(i,templ, rr)
    rr_size = rr.size-1

    return false if templ[0] =='w' && i!=1
    return false if templ[-1] =='w' && i!=rr.size-1

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
    #p found_wrong
    return found_wrong.empty?

  end

  #############analize each piece
  def self.anlz_I(rr)
    res=[]
    for i in 1..rr.size-1
      res<< [i+1,1, rr[i+1]+4]  if fit_tmpl(i,['+2','0','+2'] , rr)
      res<< [i,1, rr[i]+4]    if fit_tmpl(i,['0','u2'] , rr)
      res<< [i,1, rr[i]+4]    if fit_tmpl(i,['w','0','u2'] , rr)
      res<< [i+1,1, rr[i+1]+4]   if fit_tmpl(i,['u2','0'] , rr)
      res<< [i+1,1, rr[i+1]+4]    if fit_tmpl(i,['u2','0','w'] , rr)
      res<< [i,0, rr[i]]    if fit_tmpl(i,['0', '0', '0', '0','w'] , rr)
      res<< [i,0, rr[i]]    if fit_tmpl(i,['w','0', '0', '0', '0'] , rr)
      res<< [i,0, rr[i]+1]    if fit_tmpl(i,['0', '0', '0', '0'] , rr)
    end
    res
  end

  def self.anlz_J(rr)
    res=[]
    for i in 1..rr.size-1
      #0
      #  #
      #  ###
      res<< [i,0, rr[i]+2]  if fit_tmpl(i,['0','0','0'] , rr)
      res<< [i+1,0, rr[i+1]+2]  if fit_tmpl(i,['u1','0','0','0'] , rr)

      #1  #
      #   #
      #  ##
      res<< [i,1, rr[i+1]+3]  if fit_tmpl(i,['0','0','u2'] , rr)
      res<< [i+1,1, rr[i+2]+3]  if fit_tmpl(i,['u2','d1','0','u2'] , rr)

      #2
      #  ###
      #    #
      res<< [i,2, rr[i]+1]  if fit_tmpl(i,['0','0','-1'] , rr)
      res<< [i,2, rr[i]+1+1]  if fit_tmpl(i,['0','0','d2'] , rr) #added +1 because of gap
      res<< [i,2, rr[i+1]+1+1]  if fit_tmpl(i,['-1','0','-1'] , rr) #added +1 because of gap

      #3 ##
      #  #
      #  #
      res<< [i,3, rr[i]+3]  if fit_tmpl(i,['0','+2'] , rr)
      res<< [i+1,3, rr[i+2]+1]  if fit_tmpl(i,['u1','d2','0','u1'] , rr)
    end
    res
  end

  def self.anlz_L(rr )
    res=[]
    for i in 1..rr.size-1
      #0   #
      #  ###

      res<< [i,0, rr[i]+2]  if fit_tmpl(i,['0','0','0'] , rr)
      res<< [i,0, rr[i]+2]  if fit_tmpl(i,['0','0','0','u1'] , rr)

      #1 ##
      #   #
      #   #
      res<< [i,1, rr[i]+1]  if fit_tmpl(i,['+2','0','u1'] , rr)
      res<< [i,1, rr[i]+1]  if fit_tmpl(i,['+2','0'] , rr)
      res<< [i,1, rr[i]+1]  if fit_tmpl(i,['u2','0'] , rr)

      #2
      #  ###
      #  #
      res<< [i,2, rr[i+1]+1]  if fit_tmpl(i,['-1','0','0'] , rr)
      res<< [i,2, rr[i+1]+1+1]  if fit_tmpl(i,['d2','0','0'] , rr) #added +1 because of gap
      res<< [i,2, rr[i+1]+1+1]  if fit_tmpl(i,['-1','0','-1'] , rr) #added +1 because of gap

      #3  #
      #   #
      #   ##
      res<< [i+1,3, rr[i+1]+3]  if fit_tmpl(i,['+2','0','0'] , rr)
      res<< [i,3, rr[i]+3]      if fit_tmpl(i,['w','0','0'] , rr)
      res<< [i+1,3, rr[i+1]+3]  if fit_tmpl(i,['u2','0','-1'] , rr)

    end
    res
  end


  def self.anlz_O(rr)
    res=[]
    for i in 1..rr.size-1
      res<< [i+1,0, rr[i+1]+2,"u1 0 0" ]  if fit_tmpl(i,['u1','0','0'] , rr)
      res<< [i,0, rr[i]+2,"0 0 u1"]  if fit_tmpl(i,['0','0','u1'] , rr)
      res<< [i,0, rr[i]+2,"w 0 0"]  if fit_tmpl(i,['w','0','0'] , rr)
      res<< [i,0, rr[i]+2, "0 0 w"]  if fit_tmpl(i,['0','0','w'] , rr)
      res<< [i,0, rr[i]+2+1, "0 0"]  if fit_tmpl(i,['0','0'] , rr)
      res<< [i,0, rr[i+1]+2+1, "d1 0"]  if fit_tmpl(i,['d1','0'] , rr) # gap
      res<< [i,0, rr[i]+2+1, "0 d1"]  if fit_tmpl(i,['0','d1'] , rr)   # gap
    end
    res
  end


  #########
  def self.anlz_S(rr)
    res=[]
    for i in 1..rr.size-1

      res<< [i,0, rr[i+2]+1]  if fit_tmpl(i,['0','0','+1'] , rr)
      res<< [i,0, rr[i+2]+1+1]  if fit_tmpl(i,['d1','d1','0'] , rr) #added +1 because of gap
      res<< [i,0, rr[i+2]+3]  if fit_tmpl(i,['0','0','0'] , rr) #added +1 because of gap
      res<< [i,1, rr[i]+2]  if fit_tmpl(i,['+1','0'] , rr)
      res<< [i,1, rr[i]+2]  if fit_tmpl(i,['w','0','d1','u2'] , rr)
      res<< [i+1,1, rr[i+1]+2]  if fit_tmpl(i,['u1','0','d1','u2'] , rr)
    end

    res
  end

  def self.anlz_Z(rr)
    res=[]
    for i in 1..rr.size-1
      res<< [i,0, rr[i]+1, "+1 0 0"]  if fit_tmpl(i,['+1','0','0'] , rr)
      res<< [i,0, rr[i]+1+1, "0 -1 d1"]  if fit_tmpl(i,['0','-1','d2'] , rr) #gap
      res<< [i,0, rr[i]+3, "0 0 0"]  if fit_tmpl(i,['0','0','0'] , rr)
      res<< [i,1, rr[i]+3, "0 +1"]  if fit_tmpl(i,['0','+1'] , rr)
      res<< [i,1, rr[i]+3, "w 0 +1 u2"]  if fit_tmpl(i,['w','0','+1','u2'] , rr)
      res<< [i,1, rr[i]+3, "0 +1 u2"]  if fit_tmpl(i,['0','+1','u2'] , rr)
    end
    res
  end

  ###########
  def self.anlz_T(rr)
    res=[]
    for i in 1..rr.size-1
      res<< [i,0, rr[i+1]+2]  if fit_tmpl(i,['0','0','0'] , rr)
      res<< [i,0, rr[i+1]+2]  if fit_tmpl(i,['-1','0','0'] , rr)
      res<< [i,0, rr[i+1]+2]  if fit_tmpl(i,['0','0','-1'] , rr)

      res<< [i,1, rr[i+1]+3]  if fit_tmpl(i,['+1','0','u1'] , rr)
      res<< [i+1,1, rr[i+1]+2]  if fit_tmpl(i,['u1','0','d1'] , rr)
      res<< [i,1, rr[i]+2]  if fit_tmpl(i,['w','0','d1','u1'] , rr)

      res<< [i,2, rr[i]+1]  if fit_tmpl(i,['0','-1','0'] , rr)

      res<< [i+1,3, rr[i+1]+3]  if fit_tmpl(i,['u1','0','+1'] , rr)
      res<< [i,3, rr[i+2]+2]  if fit_tmpl(i,['u1','d1','0','w'] , rr)
    end
    res
  end



end
