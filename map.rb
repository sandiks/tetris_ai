require_relative  'bot'

class Map
 def self.set_piece(rr, type)

    pos =  case type
    when 'I'; Bot.anl_I rr
    when 'J'; Bot.anl_J rr
    when 'L'; Bot.anl_L rr
    when 'O'; Bot.anl_O rr
    when 'S'; Bot.anl_S rr
    when 'Z'; Bot.anl_Z rr
    when 'T'; Bot.anl_T rr

    end
    change_field(rr,type,pos)

  end

  def self.change_field(rr, p_type, pos)
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
      when 1; r0+=1;r1+=2;r2+=1;
      when 2; r0+=2;r1+=2;
      end

    when 'Z'
      case po
      when 1; r0+=1;r1+=2;r2+=1;
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

  def self.draw_field(row, field)

    p "Field 10x20"

    for i in 1..10
    	
    	last = field[i].reverse.index('#')
    	last = 20 if last.nil?
    	last = field[i].size - last
    	diff = row[i]-last

    	field[i][last..row[i]-1] = "*"*diff if diff >0
    	p "#{field[i]}| last #{last} curr #{row[i]}"
    	field[i].gsub!('*','#')
    	#p "last #{last} curr#{row[i]}"
    end


  
  end
end
