
require_relative  'helper'



class BBLogic

  def self.fact(l,r,rr)

    if l <1
      left = 2
    elsif r>rr.size-1
      right = 2
    end
    left= rr[l]-rr[l+1]  if l>=1
    right= rr[r]-rr[r-1] if r<=rr.size-1

    (left+right) /2 
  end

  #############analize each piece
  def self.anlz_I(rr)
    res=[]
    for i in 1..rr.size-1
      r0,r1,r2 = rr[i], rr[i+1], rr[i+2]

      t = "0 0 0 0";      res<< [[i,r0],0,   rr[i]+1-fact(i-1,i+4,rr),t]      if fit_tmpl(i,t, rr)
      t = "0 u1";         res<< [[i,r0],1, rr[i]+4-fact(i-1,i+1,rr), t]       if fit_tmpl(i,t, rr)
      t = "u1 0";         res<< [[i+1,r1],1, rr[i+1]+4-fact(i,i+2,rr), t]       if fit_tmpl(i,t, rr)
    end
    res
  end


  #####J
  def self.anlz_J(rr)
    res=[]

    for i in 1..rr.size-1
      r0,r1,r2 = rr[i], rr[i+1], rr[i+2]
      #0
      t = "0 0 0";      res<< [[i,r0],0, rr[i]+2-fact(i-1,i+3,rr),t]       if fit_tmpl(i,t, rr)
      #1
      t = "0 0";        res<< [[i,r0],1, rr[i+1]+3-fact(i-1,i+2,rr),t]      if fit_tmpl(i,t, rr)
      t = "d1 0";       res<< [[i,r1],1, rr[i+1]+3+r1-r0,t]   if fit_tmpl(i,t, rr) #gap
      #2 ###
      #    #
      t = "0 0 -1";     res<< [[i,r1-1],2, rr[i]+r0-r2-fact(i-1,i+3,rr),t]   if fit_tmpl(i,t, rr) #gap
      t = "0 0 d2";     res<< [[i,r1-1],2, rr[i]+2*(r0-r2)-fact(i-1,i+3,rr),t]   if fit_tmpl(i,t, rr) #gap
      #t = "-1 0 -1";    res<< [[i,r1-1],2, rr[i+1]+1+3,t] if fit_tmpl(i,t, rr) #gap
      #3
      t = "d2 0";       res<< [[i,r1-2],3, rr[i+1]+r1-r0-1-fact(i-1,i+2,rr),t]  if fit_tmpl(i,t, rr)
    end
    res
  end

  def self.anlz_L(rr )
    res=[]


    for i in 1..rr.size-1
      r0,r1,r2 = rr[i], rr[i+1], rr[i+2]
      #0
      t = "0 0 0";      res<< [[i,r0],0, rr[i]+2-fact(i-1,i+3,rr),t]  if fit_tmpl(i,t, rr)
      #3  #
      t = "0 0";        res<< [[i,r0],3, rr[i]+3,t]  if fit_tmpl(i,t, rr)
      t = "0 d1";       res<< [[i,r0],3, rr[i]+3+ r0-r1,t]  if fit_tmpl(i,t, rr)
      #2  ###
      #   #
      t = "-1 0 0";       res<< [[i,r1-1],2, rr[i+1]+r2-r0-fact(i-1,i+3,rr),t]   if fit_tmpl(i,t, rr) #added +1 because of gap
      t = "d2 0 0";       res<< [[i,r1-1],2, rr[i+1]+2*(r2-r0)-fact(i-1,i+3,rr),t]   if fit_tmpl(i,t, rr) #added +1 because of gap
      t = "-1 0 -1";      res<< [[i,r1-1],2, rr[i]+1+1,t]   if fit_tmpl(i,t, rr) #added +1 because of gap
      #1
      t = "0 d2";         res<< [[i,r0-2],1, rr[i]+r0-r1-1-fact(i-1,i+2,rr),t]     if fit_tmpl(i,t, rr)



    end
    res
  end


  def self.anlz_O(rr)
    res=[]

    for i in 1..rr.size-1
      r0,r1,r2 = rr[i], rr[i+1], rr[i+2]

      t = "0 0";          res<< [[i,r0],0, rr[i]+2,t]      if fit_tmpl(i,t, rr)
      t = "d1 0";         res<< [[i,r1],0, rr[i+1]+2+r1-r0,t]   if fit_tmpl(i,t, rr) # gap
      t = "0 d1";         res<< [[i,r0],0, rr[i]+2+r0-r1,t]     if fit_tmpl(i,t, rr)   # gap
      t = "d2 0 0 0";     res<< [[i+2,r2],0, rr[i+2]+1,t]       if fit_tmpl(i,t, rr) # gap
      t = "0 0 0 d2";     res<< [[i,r0],0, rr[i]+1,t]           if fit_tmpl(i,t, rr) # gap
    end
    res
  end


  #########
  def self.anlz_S(rr)
    res=[]
    for i in 1..rr.size-1
      r0,r1,r2 = rr[i], rr[i+1], rr[i+2]

      t = "d1 -1 0";    res<< [[i,r1],0, rr[i+2]+1+r1-r0,t]  if fit_tmpl(i,t, rr) #gap
      t = "0 0 0";      res<< [[i,r0],0, rr[i]+4, t]         if fit_tmpl(i,t, rr) #gap
      t = "w 0 0 0";    res<< [[i,r0],0, rr[i]+3, t]         if fit_tmpl(i,t, rr) #gap

      t = "0 d1";       res<< [[i,r0-1],1, rr[i]+1+ r0-r1,t]   if fit_tmpl(i,t, rr) #gap
    end

    res
  end

  def self.anlz_Z(rr)
    res=[]
    for i in 1..rr.size-1
      r0,r1,r2 = rr[i], rr[i+1], rr[i+2]

      t = "0 -1 d1";    res<< [[i,r1],0, rr[i]+1+r1-r2,t]  if fit_tmpl(i,t, rr) #gap
      t = "0 0 0";      res<< [[i,r0],0, rr[i]+4,t]    if fit_tmpl(i,t, rr)
      t = "0 0 0 w";    res<< [[i,r0],0, rr[i]+3,t]    if fit_tmpl(i,t, rr)
      t = "d1 0";       res<< [[i,r1-1],1, rr[i+1]+1+r1-r0,t]    if fit_tmpl(i,t, rr) #gap
    end
    res
  end

  ###########
  def self.anlz_T(rr)
    res=[]

    for i in 1..rr.size-1
      r0,r1,r2 = rr[i], rr[i+1], rr[i+2]

      t = "0 0 0";      res<< [[i,r0], 0, rr[i+1]+2,t]    if fit_tmpl(i,t,rr)
      t = "-1 0 0";     res<< [[i,r1], 0, rr[i+1]+2+1,t]       if fit_tmpl(i,t,rr) #gap
      t = "0 0 -1";     res<< [[i,r0], 0, rr[i+1]+2+1, t]       if fit_tmpl(i,t, rr) #gap

      t = "0 d1";       res<< [[i,r0-1],  1, rr[i]+1+r0-r1,t]    if fit_tmpl(i,t, rr)
      t = "0 d1 0";     res<< [[i,r0-1],  2, rr[i]+r0-r1,t]       if fit_tmpl(i,t, rr)
      t = "d1 0";       res<< [[i,r1-1],  3, rr[i+1]+1+r1-r0,t]       if fit_tmpl(i,t, rr)
    end
    res
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


end
