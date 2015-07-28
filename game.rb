require_relative  'bot_I'
require_relative  'bot_J'
require_relative  'bot_L'
require_relative  'bot_O'
require_relative  'bot_S'
require_relative  'bot_T'
require_relative  'bot_Z'
require_relative  'helper'

class Settings
  attr_accessor :timebank, :time_per_move, :your_bot, :field_width, :field_height
end

class Player
  attr_accessor :row_points, :combo, :field
end

class Map
  attr_accessor :field, :rr, :gaps, :w, :h
  def initialize
    @field = Array.new(11) { ' '*20 }
    @rr = Array.new(11,0)
    @gaps = Array.new(11,0)
    @w=10
    @h=20
  end
end

class Game
  attr_accessor :round, :this_piece_type, :next_piece_type, :time_left
  attr_accessor :map, :my, :other

  def initialize
    @map = Map.new
    @my = Player.new
    @other = Player.new
  end
end

class BlackBox
  def self.make_movies(game, type)
  	mm = game.map

  end

  def self.detect_position(map, ptype)

    rr =map.rr
    p res = check_gaps(map, ptype)
    return if not res.nil?

    pos =  case ptype
    when 'I'; BotI.anlz rr
    when 'J'; BotJ.anlz rr
    when 'L'; BotL.anlz rr
    when 'O'; BotO.anlz rr
    when 'S'; BotS.anlz(map, ptype)
    when 'Z'; BotZ.anlz(map, ptype)
    when 'T'; BotT.anlz(map, ptype)

    end

    p "detected postion #{pos} for  #{ptype}"
    set_piece(map, ptype, pos)

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
      case p
        when 0; r0+=1;r1+=1;r2+=1;rr[i+3]+=1;
        when 1; r0+=4
      end

    when 'J'
      case po
      when 0; r0+=2; r1+=1; r2+=1;
      when 1; r0+=1; r1+=3;
      when 2; r0+=1; r1+=1; r2+=2;
      when 3; r0+=1; r1+=3;
      end

    when 'L'
      case po
      when 0; r0+=1;r1+=1;r2+=2;
      when 1; r0+=1;r1+=3;
      when 2; r0+=2;r1+=1;r2+=1;
      when 3; r0+=3;r1+=1;
      end

    when 'O'; r0+=2;r1+=2;

    when 'S'
      case po
      when 0;
        gg[i+2]=r2+1 if r1==r2
        r0+=1;r1+=2;r2=r1;

      when 1; r0+=2;r1+=2;
      end

    when 'Z'
      case po
      when 0; r1+=2; r0=r1; r2+=1;
      when 1; r0+=2;r1+=2;
      end


    when 'T'
      case po
      when 1; r0+=1;r1+=2;r2+=1;
      when 2; r0+=3;r1+=1;
      when 3; r0+=1;r1+=2;r2+=1;
      when 4; r0+=1;r1+=3;
      end

    end
    rr[i],rr[i+1],rr[i+2] = r0,r1,r2 if i<map.w-2
    rr[i],rr[i+1] = r0,r1 if i== map.w-1
    rr[i] = r0 if i== map.w

  end


end
