require_relative  'bot'
require_relative  'helper'

class BlackBox

  def self.detect_position(map, ptype)

    rr =map.rr
    res = check_gaps(map, ptype)
    return if not res.nil?

    pos = anlz(map, ptype)
    #set_piece(map, ptype, pos)

  end

  def self.anlz(map, piece_type)

    ruls = load_rules(piece_type)
    rr = map.rr #get top line

    max = rr.max
    min = rr.min

    res=[]


    #check rules
    for i in 1..map.w

      #find right rule
      ruls.each do |rl|
        orient = rl[0].to_i #piece oriented index
        stt = rl[1]

        next if i+stt.size>map.w+1

        line = stt.map { |ss|  ss.start_with?('0') ? '0' :  ss[0]  }

        hh = stt.map { |ss|  ss.to_i  }

        found =  case piece_type
        when 'I'; anlz_I(i,line,hh,rr)
        when 'J'; anlz_J(i,line,hh,rr)
        when 'L'; anlz_L(i,line,hh,rr)
        when 'O'; anlz_O(i,line,hh,rr)
        when 'S'; anlz_S(i,line,hh,rr)
        when 'Z'; anlz_Z(i,line,hh,rr)
        when 'T'; anlz_T(i,line,hh,rr)
        end

        unless found.nil?
          res<< (found<<orient)
          #p found
        end
      end
    end

    find_max_compatibility(res)
  end


  #############analize each piece


  def self.anlz_I(i, line, hh, rr )
    found =case line
    when ['0', '+'];            [i,   rr[i],    10] if rr[i] == rr[i+1]-hh[1]
    when ['+', '0'];            [i+1, rr[i+1],  10] if rr[i]-hh[0] == rr[i+1]
    when ['0', '0', '0', '0'];  [i,   rr[i],    8] if fit_row_line(rr, i, ['0','0','0','0'])
    end
  end

  def self.anlz_J(i, line, hh, rr )

    found =case line
    when ['0', '0', '-']; [i, rr[i],    10]       if rr[i] == rr[i+1] && rr[i+1] == rr[i+2]-hh[2]
    when ['0', '0', '+']; [i, rr[i],    7+hh[2]]  if rr[i] == rr[i+1] && rr[i+1] == rr[i+2]-hh[2]
    when ['0', '+'];      [i, rr[i],  9]          if rr[i] == rr[i+1]-hh[1]
    when ['0', '0', '0']; [i, rr[i],    5]        if rr[i] == rr[i+1] && rr[i+1] == rr[i+2]
    when ['0', '0'];      [i,   rr[i],    8]      if rr[i] == rr[i+1]
    end

  end

  def self.anlz_L(i, line, hh, rr )

    found =case line
    when ['-','0', '0'];  [i, rr[i],    10]      if rr[i]-hh[0] == rr[i+1] && rr[i+1] == rr[i+2]
    when ['+', '0'];      [i, rr[i+1],   9]      if rr[i]-hh[0] == rr[i+1]
    when ['+','0', '0'];  [i+1, rr[i+1],   7+hh[0]]  if rr[i]-hh[0] == rr[i+1] && rr[i+1] == rr[i+2]
    when ['0', '0', '0']; [i, rr[i],     5]      if rr[i] == rr[i+1] && rr[i+1] == rr[i+2]
    end

  end

  def self.anlz_O(i, line, hh, rr )
    bonus = ( i==0 || i == rr.size-1 ? 1 : 0 )

    found =case line
    when ['0', '0', '+']; [i,   rr[i],    9+bouns] if rr[i] == rr[i+1] && rr[i+1] == rr[i+2]-hh[2]
    when ['+', '0', '0']; [i+1, rr[i+1],  9+bonus] if rr[i]-hh[0] == rr[i+1] && rr[i+1] == rr[i+2]
    when ['0', '0'];      [i,   rr[i],    8+bonus]  if rr[i] == rr[i+1]

    end
  end


  #########
  def self.anlz_S(i, line, hh, rr )

    found =case line
    when ['0', '0', '+']; [i, rr[i],    10] if rr[i] == rr[i+1] && rr[i+1] == rr[i+2]-hh[2]
    when ['+', '0'];      [i, rr[i+1],  9] if rr[i]-hh[0] == rr[i+1]
    when ['0', '0', '0']; [i, rr[i],    0] if rr[i] == rr[i+1] && rr[i+1] == rr[i+2]

    end

  end

  ###########
  def self.anlz_T(i, line, hh, rr )

    found =case line
    when ['+', '0', '+']; [i, rr[i+1],  10]    if rr[i]-hh[0] == rr[i+1] && rr[i+1] == rr[i+2]-hh[2]
    when ['0', '+'];      [i, rr[i],     7]   if rr[i] == rr[i+1]-hh[1]
    when ['+', '0'];      [i, rr[i+1],   7]     if rr[i]-hh[0] == rr[i+1]
    when ['0', '0', '0']; [i, rr[i],     9]    if rr[i] == rr[i+1] && rr[i+1] == rr[i+2]

    end

  end

  #############
  def self.anlz_Z(i, line, hh, rr )
    found =case line
    when ['+','0','0'];   [i, rr[i+1],   10] if rr[i]-hh[0] == rr[i+1] && rr[i+1] == rr[i+2]
    when ['0', '+'];      [i, rr[i],     9] if rr[i] == rr[i+1]-hh[1]
    when ['0', '+', '+']; [i, rr[i],     8] if rr[i] == rr[i+1]-hh[1] && rr[i+1]-hh[1] == rr[i+2]-hh[2]
    when ['-', '0', '+']; [i, rr[i+1],   6] if rr[i]-hh[0] == rr[i+1] && rr[i+1] == rr[i+2]-hh[2]
    when ['0', '0', '0']; [i, rr[i],     5] if rr[i] == rr[i+1] && rr[i+1] == rr[i+2]

    end
  end

 


end
