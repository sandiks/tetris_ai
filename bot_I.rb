require_relative  'helper'

class BotI



  def self.anlz(rr)
    max = rr.max
    min = rr.min
    diff_not_big = max-min<4
    res=[]
    #
    #
    #
    #
    for i in 1..9
      res<< [i,1,rr[i]] if rr[i+1] - rr[i] >= 3
      res<< [i+1,1,rr[i+1]] if rr[i] - rr[i+1] >= 3

    end

    ####
    for i in 1..7
      level = true
      3.times { |k| level = false if  rr[i+k]!= rr[i+k+1]}

      res<< [i,2,rr[i]] if level
    end
    p res

    find_min_level(res)

  end
end