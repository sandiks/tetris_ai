
def find_min_level(pos)
  min= pos.map{|el| el[2]}.min
  res= pos.find{|a| a[2] == min}

  if res.nil?

    pos.first
  else
    res
  end

end
def find_max_compatibility(pos)
  max= pos.map{|el| el[3]}.max
  res= pos.find{|a| a[3] == max}

  if res.nil?
    pos.first
  else
    res
  end

end

def load_rules(ptype)

  res = []

  file = case ptype
  when 'I'; "rules/rI.dt"
  when 'J'; "rules/rJ.dt"
  when 'L'; "rules/rL.dt"
  when 'O'; "rules/rO.dt"
  when 'S'; "rules/rS.dt"
  when 'Z'; "rules/rZ.dt"
  when 'T'; "rules/rT.dt"
  end

  File.open(file, "r").each do |line|
    next if /\S/ !~ line
   
    arr = line.split(":")
    res << [arr[0], arr[1].split(' ')]
  end
  res
end
