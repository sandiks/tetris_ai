require_relative  'bot_I'
require_relative  'bot_J'
require_relative  'bot_L'
require_relative  'bot_O'
require_relative  'bot_S'
require_relative  'bot_T'
require_relative  'bot_Z'


class Map
  attr_accessor :field, :rr, :gaps

  def initialize
    @field = Array.new(11) { ' '*20 }
    @rr = Array.new(11,0)
    @gaps = Array.new(11,0)
  end
end

class MapPrinter
  def self.detect_position(map, type)

    rr =map.rr

    pos =  case type
    when 'I'; BotI.anlz rr
    when 'J'; BotJ.anlz rr
    when 'L'; BotL.anlz rr
    when 'O'; BotO.anlz rr
    when 'S'; BotS.anlz(map,type)
    when 'Z'; BotZ.anlz rr
    when 'T'; BotT.anlz(map,type)

    end

    p "detected postion #{pos} for  #{type}"
    set_piece(map,type,pos)

  end

  def self.set_piece(map, p_type, pos)
    rr = map.rr
    gg = map.gaps

    if pos.nil?

      return
    end

    i = pos[0]
    po = pos[1]
    r0,r1,r2 = rr[i],rr[i+1],rr[i+2]

    case p_type

    when 'I'
      if po == 1
        r0+=4
      else
        r0+=1;r1+=1;r2+=1;rr[i+3]+=1;
      end

    when 'J'
      case po
      when 1; r0+=1; r1+=3;
      when 2; r0+=1; r1+=1; r2+=2;
      when 3; r0+=1; r1+=3;
      when 4; r0+=2; r1+=1; r2+=1;
      end

    when 'L'
      case po
      when 1; r0+=3;r1+=1;
      when 2; r0+=1;r1+=1;r2+=2;
      when 3; r0+=1;r1+=3;
      when 4; r0+=2;r1+=1;r2+=1;
      end

    when 'O'; r0+=2;r1+=2;

    when 'S'
      case po
      when 1;
        gg[i+2]=r2+1 if r1==r2
        r0+=1;r1+=2;r2=r1;

      when 2; r0+=2;r1+=2;
      end

    when 'Z'
      case po
      when 1; r1+=2; r0=r1; r2+=1;
      when 2; r0+=2;r1+=2;
      end


    when 'T'
      case po
      when 1; r0+=1;r1+=2;r2+=1;
      when 2; r0+=3;r1+=1;
      when 3; r0+=1;r1+=2;r2+=1;
      when 4; r0+=1;r1+=3;
      end

    end
    rr[i],rr[i+1],rr[i+2] = r0,r1,r2

  end

  def self.draw_field(map)

    field = map.field
    row = map.rr

    p "Field 10x20"

    for i in 1..10
      ll = field[i]

      last = ll.rindex('o')
      last = 0 if last.nil?

      diff = row[i]-last

      ll[last+1..row[i]] = "+"*diff if diff >0
      ll[map.gaps[i]] = ' ' if map.gaps[i]!=0
      ll[0] = '|'

      
      p "#{ll}| last #{last} curr #{row[i]}"
      ll.gsub!('+','o')
    end

  end
end
