require_relative  'game'
require_relative  'bb'
require_relative  'bb_gaps'
require_relative  'bot'

####update game

def set_settings(arr,stt)
  case arr[1]
  when "timebank"; stt.timebank = arr[2].to_i
  when "time_per_move"; stt.time_per_move = arr[2].to_i
  when "your_bot"; stt.your_bot = arr[2]
  when "field_height"; stt.field_height = arr[2].to_i
  when "field_width"; stt.field_width = arr[2].to_i
  end
end

def update_game(arr,gg)

  case arr[2]
  when "round"; gg.round = arr[3].to_i
  when "this_piece_type"; gg.this_piece_type = arr[3].strip
  when "next_piece_type"; gg.next_piece_type = arr[3].strip
  when "this_piece_position";  gg.this_piece_position = arr[3].split(',').map { |e| e.to_i  }

  end
end

def update_player(arr,plr)

  case arr[2]
  when "row_points"; plr.row_points = arr[3].to_i
  when "combo"; plr.combo = arr[3].to_i
  when "field"; plr.field = arr[3]
  end
end

#####
def calc_turnes(ptype,orient)

  tr = "turnright"
  tl = "turnleft"
  turnes = []
  shift_x=0
  shift_y=0

  case ptype
  when 'I';
    case orient
    when 1;  turnes=[tl]; shift_x=1; shift_y=2
    when 2;  turnes=[tr]; shift_x=2; shift_y=2
    end

  when 'J';
    case orient
    when 1;  turnes=[tl]; shift_y=1
    when 2;  turnes=[tl,tl]; shift_y=1
    when 3 ; turnes = [tr]; shift_x=1
    end


  when 'L'
    case orient
    when 1;  turnes=[tl]; shift_y=1
    when 2;  turnes=[tl,tl]; shift_y=1
    when 3 ; turnes = [tr]; shift_x=1
    end

  when 'O'; shift_y=1;

  when 'S';  if orient==1; turnes=[tl]; shift_y=1; end

  when 'Z';  if orient==1; turnes=[tl]; shift_y=1; end

  when 'T';
    case orient
    when 1; turnes=[tl];shift_y=2;
    when 2; turnes=[tl,tl];shift_y=2;
    when 3; turnes = [tr]; shift_x=1; shift_y=2
    end
  end

  {shift_x: shift_x, shift_y: shift_y, turnes: turnes}
end


#######

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

  dir = File.dirname(__FILE__)
  file = File.join(dir,file)

  File.open(file, "r").each do |line|
    next if /\S/ !~ line

    arr = line.split(":")
    cost = arr.size>2 ? arr[2].to_i : 3

    res << [arr[0], arr[1].split(' '), cost]
  end

  res
end

def show_field_h(map,last=nil)

  field = map.field
  rr = map.rr
  gg = map.gaps
  p "Field 10x20"
  #p "gaps: #{map.gaps}"
  #p "last:#{last} rr:#{rr}"

  for i in 1..map.w

    ll = field[i]

    ll = ' '*map.h
    ll[0]='|'
    last =rr if last.nil?

    top = [last[i], rr[i]].min
    ll[1..top] = "o"*top if top!=0
    ll[top+1..rr[i]] = "+"*(rr[i]-last[i]) if rr[i]-last[i]>=0

    ll[gg[i]] = '-' if gg[i]!=0
    p "#{ll}|#{i}: (last,rr) #{last[i]}-#{rr[i]} gg=#{gg[i]}"
  end
end

def show_field(map,last=nil)

  field = map.field
  rr = map.rr
  gg = map.gaps
  p "Field 10x20"

  for i in 1..map.w


    ll = field[i]
    ll = ' '*map.h
    ll[0]='|'
    last =rr if last.nil?

    ll[1..last[i]] = "o"*last[i] if last[i]!=0
    ll[last[i]+1..rr[i]] = "x"*(rr[i]-last[i]) if last[i]!=rr[i]

    ll[gg[i]] = '-' if gg[i]!=0
    field[i] = ll

  end
  #p rr
  #p last


  10.downto(1) do |h|
    line = "|"
    for x in 1..map.w
      line<<field[x][h]
    end
    p line<<"|"
  end
end

#############find best variant
def find_min_level(pos)
  min= pos.map{|a| a[2]}.min
  res= pos.find{|a| a[2] == min}
end

def find_max_compatibility(pos)
  max= pos.map{|el| el[2]}.max
  res= pos.select{|a| a[2] == max}
  #return find_min_level(res)

  if res.size>1
    find_min_level(res)
  else
    res.first
  end

end
