require_relative  'helper'

class BotZ


  def self.anlz(map, piece_type)
    ruls = load_rules(piece_type)
    rr = map.rr #get top line

    max = rr.max
    min = rr.min
    diff_not_big = max-min<4
    res=[]


    #check rules
    for i in 1..map.w

      #find right rule
      ruls.each do |rl|
        orient = rl[0].to_i #piece oriented index
        stt = rl[1]

        break if i+stt.size>11

        line = stt.map { |ss|  ss.start_with?('0') ? '0' :  ss[0]  }
        hh = stt.map { |ss|  ss.to_i  }

        #[pos, ptype, min_row_index, compatibility]
        found =case line
        when ['+','0','0'];   [i, orient, rr[i],    10] if rr[i]-hh[0] == rr[i+1] && rr[i+1] == rr[i+2] && i<map.w-1
        when ['0', '+'];      [i, orient, rr[i],     9] if rr[i] == rr[i+1]-hh[1] && i<map.w
        when ['0', '+', '+']; [i, orient, rr[i],     0] if rr[i] == rr[i+1]-hh[1] && rr[i+1]-hh[1] == rr[i+2]-hh[2] && i<map.w-1
        when ['0', '0', '0']; [i, orient, rr[i],     0] if rr[i] == rr[i+1] && rr[i+1] == rr[i+2] && i<map.w-1

        end

        unless found.nil?
          res<<found
          #p found

        end
      end

    end

    #find_min_level(res)
    find_max_compatibility(res)
  end
end
