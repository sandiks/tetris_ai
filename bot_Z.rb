require_relative  'helper'

class BotZ


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

        break if i+stt.size>map.w+1

        line = stt.map { |ss|  ss.start_with?('0') ? '0' :  ss[0]  }
        
        hh = stt.map { |ss|  ss.to_i  }

        #[x_pos, orient, min_row_y, compatibility]

        found =case line
        when ['+','0','0'];   [i, rr[i+1],  orient, 10] if rr[i]-hh[0] == rr[i+1] && rr[i+1] == rr[i+2] 
        when ['0', '+'];      [i, rr[i],    orient, 9] if rr[i] == rr[i+1]-hh[1] 
        when ['0', '+', '+']; [i, rr[i],    orient, 8] if rr[i] == rr[i+1]-hh[1] && rr[i+1]-hh[1] == rr[i+2]-hh[2] 
        when ['-', '0', '+']; [i, rr[i+1],  orient, 6] if rr[i]-hh[0] == rr[i+1] && rr[i+1] == rr[i+2]-hh[2] 
        when ['0', '0', '0']; [i, rr[i],    orient, 5] if rr[i] == rr[i+1] && rr[i+1] == rr[i+2] 

        end

        unless found.nil?
          res<<found
          #p found
        end
      end
    end

   find_max_compatibility(res)
  end
end
