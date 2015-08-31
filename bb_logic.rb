
require_relative  'helper'



class BBLogic

  def self.bonus(l,r,rr, curr_piece, orient)
    rl2,rl1,rl0,ri=rr[l-2],rr[l-1],rr[l],rr[l+1]
    w=rr.size-1 #field width
    bb=0

    case [curr_piece,orient]

    when ['L',0];
      bb-=2 if r==w && rr[r-1]>rr[r]
      bb-=2 if l>1 && fit_tmpl(l-1,'u3 0 u2',rr)

    when ['L',1];
      bb+=1 if r==w+1
      bb-=2 if l>1 && fit_tmpl(l-1,'u3 0 u2',rr)

    when ['L',3];
      bb+=1 if l==0
      bb+=1 if l>=1 && rr[l]-rr[l+1]>1
      bb-=2 if fit_tmpl(l-1,'0 0 0',rr)
      bb-=1 if fit_tmpl(l-1,'+2 0 0',rr)
      bb-=2 if fit_tmpl(l-1,'u3 0 0',rr)


    when ['O',0];
      bb+=1 if l==0 && rr[l+1]==rr[l+2]
      bb+=1 if r==w+1 && rr[r-1]==rr[r-2]

      bb-=1 if l==1 && rr[l]<rr[l+1]
      bb-=1 if r==w && rr[r-1]>rr[r]

      ####S,Z
    when ['S',1];
      bb-=2 if l==1 && rr[l]<rr[l+1]

    when ['T',0];
      bb-=2 if r==w && rr[r-1]-rr[r]>=2
      bb-=2 if l==1 && rr[l+1]-rr[l]>=2
      bb-=2 if fit_tmpl(l-1,'u3 0 u2',rr)


    when ['T',1];
      bb-=2 if r==w && rr[r-1]-rr[r]>=0
      bb-=(rl1+ri+1-2*rl0)/3 if l>1 && fit_tmpl(l-1,'u2 0 u2',rr)

    when ['T',2];
      bb-=2 if r==w && rr[r-1]-rr[r]>=2
      
      bb-=(rl1+ri+1-2*rl0)/3 if l>1 && fit_tmpl(l-1,'u2 0 u2',rr) #rl1-rl0>=2 && rr[l+1]-rl0>=2


    when ['I',1];
      bb+=1 if l==0
      bb+=1 if r==w+1
      bb+=1 if l>=1 && rl0-ri>1
      bb+=1 if r<=w && rr[r-1]-rr[r]>1

    end

    -bb

  end

  def self.add_gap(diff,added_blocks)
    diff==0 ? 0 : added_blocks

  end
  #############analize each piece
  #res= pos,orient,level,templ,gaps

  def self.anlz_I(rr)
    res=[]
    for i in 1..rr.size-1
      r0,r1,r2 = rr[i], rr[i+1], rr[i+2]
      t = "0 0 0 0";   res<< [[i,r0],0,r0+1,t,0]      if fit_tmpl(i,t, rr)
      t = "0";         res<< [[i,r0],1,r0+4,t,bonus(i-1,i+1,rr,'I',1)]
    end
    res
  end

  def self.anlz_L(rr )
    res=[]

    for i in 1..rr.size-1
      r0,r1,r2 = rr[i], rr[i+1], rr[i+2]
      #0
      t = "0 0 0";      res<< [[i,r0],0, r0+2,t,bonus(i-1,i+2,rr,'L',0)]  if fit_tmpl(i,t, rr)
      #1
      t = "0 d2";         res<< [[i,r0-2],1, r0+1,t,add_gap(r0-r1-2,3)]  if fit_tmpl(i,t, rr)
      #t = "0 -1";         res<< [[i,r1],1, r0+2,t,1]  if fit_tmpl(i,t, rr)
      #2  ###
      #   #
      t = "d1 0 0";       res<< [[i,r1-1],2, r1+1,t, add_gap(r1-r0-1,2)]  if fit_tmpl(i,t, rr) #added +1 because of gap
      t = "-1 0 -1";      res<< [[i,r1-1],2, r1+1,t,1]                    if fit_tmpl(i,t, rr) #added +1 because of gap
      t = "d1 0 -1";      res<< [[i,r1-1],2, r1+1,t,r1-r0]        if fit_tmpl(i,t, rr) #added +1 because of gap
      #3  #
      t = "0 0";        res<< [[i,r0],3, rr[i]+3,t, bonus(i-1,i+2,rr,'L',3)]         if fit_tmpl(i,t, rr)
      t = "0 d1";       res<< [[i,r0],3, rr[i]+3,t, add_gap(r0-r1,1)]     if fit_tmpl(i,t, rr)
    end
    res
  end


  #####J
  def self.anlz_J(rr)
    w = rr.size-1
    rr1=rr.clone
    rr1[1..-1]= rr[1..-1].reverse

    orient_J=[0,3,2,1]
    shift=[3,2,3,2]

    res = anlz_L(rr1)
    res.each { |x| x[0][0]=w+2-x[0][0]-shift[x[1]]; x[1]=orient_J[x[1]]; x[3]=x[3].split(' ').reverse.join(' ')  }
    res
  end

  def self.anlz_O(rr)
    res=[]
    for i in 1..rr.size-1
      r0,r1,r2 = rr[i], rr[i+1], rr[i+2]

      t = "0 0";     res<< [[i,r0],0, r0+2,t, bonus(i-1,i+2,rr,'O',0)]      if fit_tmpl(i,t, rr)
      t = "d1 0";    res<< [[i,r1],0, r1+2,t, 2+bonus(i-1,i+2,rr,'O',0)]   if fit_tmpl(i,t, rr) # gap
      t = "0 d1";    res<< [[i,r0],0, r0+2,t, 2+bonus(i-1,i+2,rr,'O',0)]     if fit_tmpl(i,t, rr)   # gap
    end
    res
  end


  #########
  def self.anlz_S(rr)
    res=[]
    for i in 1..rr.size-1
      r0,r1,r2 = rr[i], rr[i+1], rr[i+2]

      t = "-1 -1 0";    res<< [[i,r1],0, r2+1,t,0]  if fit_tmpl(i,t, rr) #gap
      #t = "-2 -1 0";    res<< [[i,r1],0, r2+1,t,2]  if fit_tmpl(i,t, rr) #gap
      t = "d2 d1 0";    res<< [[i,r1],0, r2+1,t, 4]  if fit_tmpl(i,t, rr) #gap
      t = "0 0 0";      res<< [[i,r0],0, r0+2,t,2]    if fit_tmpl(i,t, rr)

      t = "0 d1";       res<< [[i,r0-1],1,r0+2,t, add_gap(r0-r1-1,3)+bonus(i-1,i+2,rr,'S',1)]    if fit_tmpl(i,t, rr) #gap

    end

    res
  end

  def self.anlz_Z(rr)

    w = rr.size-1

    rr1=rr.clone
    rr1[1..-1]= rr[1..-1].reverse
    shift=[3,2]

    res = anlz_S(rr1)
    res.each { |x| x[0][0]=w+2-x[0][0]-shift[x[1]]; x[3]=x[3].split(' ').reverse.join(' ')  }
    res
  end



  ###########
  def self.anlz_T(rr)
    res=[]

    for i in 1..rr.size-1
      r0,r1,r2 = rr[i], rr[i+1], rr[i+2]

      t = "0 0 0";      res<< [[i,r0],0, r1+2,t,bonus(i-1,i+3,rr,'T',0)]    if fit_tmpl(i,t,rr)
      t = "-1 0 0";     res<< [[i,r1],0, r1+2,t,1]    if fit_tmpl(i,t,rr) #gap
      t = "0 0 -1";     res<< [[i,r0],0, r1+2,t,1]    if fit_tmpl(i,t, rr) #gap

      t = "0 d1";       res<< [[i,r0-1],1, r0+2,t, add_gap(r0-r1-1,3)+bonus(i-1,i+2,rr,'T',1)]    if fit_tmpl(i,t, rr)
      t = "0 d1 0";     res<< [[i,r0-1],2, r0+1,t, add_gap(r0-r1-1,2)+bonus(i-1,i+3,rr,'T',2)]              if fit_tmpl(i,t, rr)
      t = "d1 0";       res<< [[i,r1-1],3, r1+2,t, add_gap(r1-r0-1,3)+bonus(i-1,i+2,rr,'T',3)]       if fit_tmpl(i,t, rr)
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
