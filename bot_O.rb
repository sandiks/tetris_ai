require_relative  'helper'

class BotO

  # ##
  # ##
  def self.anlz(rr)
    max = rr.max
    min = rr.min
    diff_not_big = max-min<3
    res = []
    for i in 1..9
      res<< [i,1,rr[i]] if  rr[i] == rr[i+1] && (rr[i]!=max || diff_not_big)
    end
    find_min_level(res)
  end

end
