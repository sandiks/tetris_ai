require_relative  'helper'

class BotJ

def self.anlz(map)
    rr = map.rr
    max = rr.max
    min = rr.min
    diff_not_big = max-min<3
    res=[]


    # #  
    # ###
    for i in 1..map.w-2
      res<< [i,0,rr[i]] if  rr[i] == rr[i+1] && rr[i+1] == rr[i+2] && rr[i]!=max
    end

    #  #
    #  #
    # ##
    for i in 1..map.w-1
      res<< [i,1,rr[i]] if  rr[i] == rr[i+1] && rr[i+1]!=max
    end

    # ###
    #   #
    for i in 1..map.w-2
      res<< [i,2,rr[i]] if  rr[i]+1 == rr[i+1] && rr[i+1] == rr[i+2]  && rr[i+1]!=max
    end


    #   ##
    #   #
    #   #
    for i in 1..map.w-1
      res<< [i, 3, rr[i+1]] if  rr[i]-2 == rr[i+1] && rr[i]!=max
    end

    find_min_level(res)

  end


end