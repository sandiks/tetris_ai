class Bot



  def self.anl_I(rr)
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

  #  ##
  # ##
  def self.anl_S(rr)
    max = rr.max
    min = rr.min
    diff_not_big = max-min<4
    res=[]
    for i in 1..8
      res<< [i,1,rr[i]] if rr[i+2]-1 ==rr[i+1]  && rr[i] == rr[i+1] && (rr[i+2]!=max || diff_not_big)
    end

    for i in 1..9
      res<< [i,2,rr[i+1]] if rr[i]-1 ==rr[i+1]  && (rr[i]!=max || diff_not_big)
    end
    find_min_level(res)
  end


  # ##
  #  ##
  def self.anl_Z(rr)
    max = rr.max
    min = rr.min
    diff_not_big = max-min<3
    res =[]

    for i in 1..8
      res<< [i,1,rr[i+1]] if rr[i]-1 ==rr[i+1]  && rr[i+1] == rr[i+2]  && (rr[i]!=max || diff_not_big)

    end

    for i in 1..9
      res<< [i,2,rr[i]] if rr[i]+1 ==rr[i+1] && rr[i+1]!=max
    end

    find_min_level(res)

  end

  # ##
  # ##
  def self.anl_O(rr)
    max = rr.max
    min = rr.min
    diff_not_big = max-min<3
    res = []
    for i in 1..9
      res<< [i,1,rr[i]] if  rr[i] == rr[i+1] && (rr[i]!=max || diff_not_big)
    end
     find_min_level(res)
  end

  def self.anl_T(rr)
    max = rr.max
    res=[]

    # ###
    #  #
    for i in 1..8
      res<< [i,1,rr[i+1]] if  rr[i] == rr[i+2] && rr[i+1]+1 == rr[i] && rr[i]!=max
    end

    #  #
    #  ##
    #  #
    for i in 1..9
      res<< [i,2,rr[i]] if  rr[i]+1 == rr[i+1] && rr[i+1]!=max
    end

    #  #
    # ###
    for i in 1..8
      res<< [i,3,rr[i]] if  rr[i] == rr[i+1] && rr[i+1] == rr[i+2]  && rr[i]!=max
    end
    #   #
    #  ##
    #   #
    for i in 1..9
      res<< [i,4,rr[i+1]] if  rr[i]-1 == rr[i+1] && rr[i]!=max
    end

    find_min_level(res)

  end

  def self.anl_L(rr)
    max = rr.max
    min = rr.min
    diff_not_big = max-min<3

    res = []

    #   #
    # ###
    for i in 1..8
      res<< [i,2, rr[i]] if  rr[i] == rr[i+1] && rr[i+1] == rr[i+2] && (rr[i]!=max || diff_not_big)
    end

    # ###
    # #
    for i in 1..8
      res<< [i,4, rr[i]] if  rr[i]+1 == rr[i+1] && rr[i+1] == rr[i+2]  && (rr[i]!=max || diff_not_big)
    end

    #  #
    #  #
    #  ##
    for i in 1..9
      res<< [i,1, rr[i]] if  rr[i] == rr[i+1] && (rr[i+1]!=max || diff_not_big)
    end


    #  ##
    #   #
    #   #
    for i in 1..9
      res<< [i,3, rr[i+1]] if  rr[i]-2 == rr[i+1] && (rr[i]!=max || diff_not_big)
    end

    find_min_level(res)
  end

  def self.anl_J(rr)
    max = rr.max
    min = rr.min
    diff_not_big = max-min<3
    res=[]

    # ###
    # #
    for i in 1..8
      res<< [i,4,rr[i]] if  rr[i]+1 == rr[i+1] && rr[i+1] == rr[i+2]  && rr[i+1]!=max
    end

    #   #
    # ###
    for i in 1..8
      res<< [i,2,rr[i]] if  rr[i] == rr[i+1] && rr[i+1] == rr[i+2] && rr[i]!=max
    end

    #  #
    #  #
    # ##
    for i in 1..9
      res<< [i,1,rr[i]] if  rr[i] == rr[i+1] && rr[i+1]!=max
    end


    #  ##
    #   #
    #   #
    for i in 1..9
      res<< [i, 3, rr[i+1]] if  rr[i]-2 == rr[i+1] && rr[i]!=max
    end
    find_min_level(res)

  end

  def self.find_min_level(pos)
    min= pos.map{|el| el[2]}.min
    res= pos.find{|a| a[2] == min}
    p pos
    if res.nil?
     
        pos.first
    else
        res
    end

  end
end
