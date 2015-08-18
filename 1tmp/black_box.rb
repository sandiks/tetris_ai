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

    ruls = load_rules(piece_type)
    rr = map.rr #get top line
    gg = map.gaps

    max = rr.max
    min = rr[1..map.w].min

    res=[]
    found_rules=[]


    #check rules
    ruls.each do |rule|

      orient = rule[0].to_i #piece oriented index
      stt = rule[1]
      cost = rule[2]

      for i in 1..map.w

        next if i+stt.size>map.w+1 && !stt.include?('*')
        #next if gg[i]!=0 && gg[i]<rr[i]

        line = stt.map { |ss|  ss.start_with?('0') ? '0' :  ss[0]  }
        hh = stt.map { |ss|  ss.sub('d','').sub('u','').to_i  }

        begin
          found =  case piece_type
          when 'I'; anlz_I(i,line,hh,rr)
          when 'J'; anlz_J(i,line,hh,rr)
          when 'L'; anlz_L(i,line,hh,rr)
          when 'O'; anlz_O(i,line,hh,rr)
          when 'S'; anlz_S(i,line,hh,rr)
          when 'Z'; anlz_Z(i,line,hh,rr)
          when 'T'; anlz_T(i,line,hh,rr)
          end

          if not found.nil?

            found<< cost +(max-found[1])
            found<< orient
            
            res<< found
            #found_rules<<rule
          end

        rescue
          #p "error i=#{i} rule=#{rule}"
        end

      end
    end
    find_max_compatibility(res)
  end


  #############analize each piece


  def self.anlz_I(i, line, hh, rr )

    max = rr.max

    found =case line
    when ['+','0','+'];         [i+1, rr[i+1]]   if rr[i]-hh[0] == rr[i+1] && rr[i+1] == rr[i+2]-hh[2]
    when ['0', '+'];            [i,   rr[i]]     if rr[i] == rr[i+1]-hh[1]
    when ['0', 'u'];            [i,   rr[i]]     if rr[i] <= rr[i+1]-hh[1]
    when ['*','0', 'u'];        [i,   rr[i]]     if rr[i] <= rr[i+1]-hh[1] && i==1
    when ['+', '0'];            [i+1, rr[i+1]]   if rr[i]-hh[0] == rr[i+1]
    when ['u', '0'];            [i+1, rr[i+1]]   if rr[i]-hh[0] >= rr[i+1]
    when ['u', '0', '*'];            [i+1, rr[i+1]]   if rr[i]-hh[0] >= rr[i+1] && i+1 == rr.size-1 
    when ['0', '0', '0', '0'];  [i,   rr[i]]     if fit_row_line(rr, i, ['0','0','0','0'])
    when ['*'];  [i,rr[i]] if i==1 || i==rr.size-1
    end
  end

  def self.anlz_J(i, line, hh, rr )
    max = rr.max
    found =case line
    when ['0', '0', '-']; [i, rr[i]]   if rr[i] == rr[i+1]  && rr[i+1] == rr[i+2]-hh[2]
    when ['0', '0', 'd']; [i, rr[i]]   if rr[i] == rr[i+1]  && rr[i+1] >= rr[i+2]+hh[2]
    when ['0', '0', '0']; [i, rr[i]]   if rr[i] == rr[i+1] && rr[i+1] == rr[i+2]
    when ['0', '+', '0']; [i, rr[i]]   if rr[i] == rr[i+1]-hh[1] && rr[i+1]-hh[1] == rr[i+2]

    when ['+', '0', '0', '0']; [i+1, rr[i+1]]   if fit_row_line(rr, i+1, ['0','0','0']) && rr[i]-hh[0] == rr[i+1]
    when ['0', '0', '+']; [i, rr[i]]   if rr[i] == rr[i+1] && rr[i+1] == rr[i+2]-hh[2]
    when ['0', '+'];      [i, rr[i]]   if rr[i] == rr[i+1]-hh[1]
    when ['0', '0'];      [i, rr[i]]   if rr[i] == rr[i+1]
    when ['0', '0', '*']; [i,   rr[i]]    if rr[i] == rr[i+1] && i==rr.size-2
    when ['d','0', 'u'];  [i, rr[i+1]-2]      if rr[i]+hh[0] <= rr[i+1] && rr[i+1] <= rr[i+2]-hh[2]

    end

  end

  def self.anlz_L(i, line, hh, rr )
    max = rr.max

    found =case line
    when ['-','0', '0'];  [i, rr[i+1]-1]        if rr[i]-hh[0] == rr[i+1]  && rr[i+1] == rr[i+2]
    when ['d','0', '0'];  [i, rr[i+1]-1]        if rr[i]+hh[0] <= rr[i+1]  && rr[i+1] == rr[i+2]
    when ['0', '0', '0']; [i, rr[i]]        if rr[i] == rr[i+1] && rr[i+1] == rr[i+2]
    when ['0', '+', '0']; [i, rr[i]]        if rr[i] == rr[i+1]-hh[1] && rr[i+1]-hh[1] == rr[i+2]
    when ['0', '0', '0', '+']; [i, rr[i]]   if fit_row_line(rr, i, ['0','0','0']) && rr[i+2] == rr[i+3]-hh[3]
    when ['+', '0'];      [i, rr[i]-2]      if rr[i]-hh[0] == rr[i+1]
    when ['+','0', '0'];  [i+1, rr[i+1]]    if rr[i]-hh[0] == rr[i+1] && rr[i+1] == rr[i+2]
    when ['0', '0'];      [i, rr[i]]        if rr[i] == rr[i+1]
    when ['*', '0', '0']; [i,   rr[i]]      if rr[i] == rr[i+1] && i==1
    when ['u','0', 'd'];  [i+1, rr[i+1]-2]    if rr[i]-hh[0] >= rr[i+1] && rr[i+1] >= rr[i+2]+hh[2]

    end

  end

  def self.anlz_O(i, line, hh, rr )
    bonus = ( i==0 || i == rr.size-1 ? 1 : 0 )

    found =case line
    when ['0', '0', '+']; [i,   rr[i]]    if rr[i] == rr[i+1] && rr[i+1] == rr[i+2]-hh[2]
    when ['+', '0', '0']; [i+1, rr[i+1]]  if rr[i]-hh[0] == rr[i+1] && rr[i+1] == rr[i+2]
    when ['0', '0'];      [i,   rr[i]]    if rr[i] == rr[i+1]
    when ['0', '0', '*'];      [i,   rr[i]]    if rr[i] == rr[i+1] && i==rr.size-2
    when ['*', '0', '0'];      [i,   rr[i]]    if rr[i] == rr[i+1] && i==1

    end
  end


  #########
  def self.anlz_S(i, line, hh, rr )
    max = rr.max
    found =case line
    when ['0', '0', '+']; [i, rr[i]]    if rr[i] == rr[i+1] && rr[i+1] == rr[i+2]-hh[2]
    when ['0', '0', '0']; [i, rr[i]]    if rr[i] == rr[i+1] && rr[i+1] == rr[i+2]
    when ['0', '0'];      [i, rr[i]]    if rr[i] == rr[i+1]
    when ['d', '0', '-']; [i+1, rr[i+1]]  if rr[i]+hh[0] <= rr[i+1] && rr[i+1] == rr[i+2]-hh[2]
    when ['+', '0', '-']; [i+1, rr[i+1]]  if rr[i]-hh[0] == rr[i+1] && rr[i+1] == rr[i+2]-hh[2]
    when ['u', '0', 'd']; [i+1, rr[i+1]]  if rr[i]-hh[0] >= rr[i+1] && rr[i+1] >= rr[i+2]+hh[2]
    when ['0', 'd', 'd', '0']; [i+1, rr[i+1]]  if rr[i] >= rr[i+1]+hh[1] && rr[i+3] >= rr[i+2]+hh[2]
    when ['u', 'd', 'd', '0']; [i+1, rr[i+1]]  if rr[i]-hh[0] >= rr[i+1]+hh[1] && rr[i+3] >= rr[i+2]+hh[2]

    end

  end

  def self.anlz_Z(i, line, hh, rr )
    max = rr.max

    found =case line
    when ['+','0','0'];   [i, rr[i+1]]  if rr[i]-hh[0] == rr[i+1] && rr[i+1] == rr[i+2]
    when ['0', '0', '0']; [i, rr[i]]    if rr[i] == rr[i+1] && rr[i+1] == rr[i+2]
    when ['0', '0'];      [i, rr[i],]   if rr[i] == rr[i+1]
    when ['0', '+'];      [i, rr[i]]    if rr[i] == rr[i+1]-hh[1]
    when ['-', '0', '+']; [i, rr[i+1]]  if rr[i]-hh[0] == rr[i+1] && rr[i+1] == rr[i+2]-hh[2]
    when ['d', '0', 'u']; [i, rr[i+1]]  if rr[i]+hh[0] <= rr[i+1] && rr[i+1] <= rr[i+2]-hh[2]
    when ['0', 'd', 'd', '0']; [i, rr[i]-1]  if rr[i] >= rr[i+1]+hh[1] && rr[i+3] >= rr[i+2]+hh[2]
    when ['0', 'd', 'd', 'u']; [i, rr[i]-1]  if rr[i] >= rr[i+1]+hh[1] && rr[i+3]-hh[3] >= rr[i+2]+hh[2]

    end
  end

  ###########
  def self.anlz_T(i, line, hh, rr )
    max = rr.max
    found =case line
    when ['+', '0', '+']; [i, rr[i+1]]    if rr[i]-hh[0] == rr[i+1] && rr[i+1] == rr[i+2]-hh[2]
    when ['0', '+'];      [i, rr[i]]      if rr[i] == rr[i+1]-hh[1]
    when ['+', '0'];      [i, rr[i+1]]    if rr[i]-hh[0] == rr[i+1]
    when ['0', '0', '0']; [i, rr[i]]      if rr[i] == rr[i+1] && rr[i+1] == rr[i+2]
    when ['d', '0', '+']; [i, rr[i]]      if rr[i]+hh[0] <= rr[i+1] && rr[i+1] == rr[i+2]-hh[2]
    when ['u', '0', '+']; [i, rr[i]]      if rr[i]-hh[0] >= rr[i+1] && rr[i+1] == rr[i+2]-hh[2]
    when ['+', '0', 'd']; [i, rr[i]]      if rr[i]-hh[0] == rr[i+1] && rr[i+1] >= rr[i+2]+hh[2]
    when ['+', '0', 'u']; [i, rr[i]]      if rr[i]-hh[0] == rr[i+1] && rr[i+1] <= rr[i+2]-hh[2]

    end

  end





end
