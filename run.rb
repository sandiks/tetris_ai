require_relative  'bot'
require_relative  'map'

rrow = Array.new(11,0)
field = Array.new(11) { ' '*20 }


pieces = ['I','J','L','O','S','Z','T']


12.times do
  curr = rand(7)
  diff = rrow.max - rrow.min
  p "rand=#{curr} type=#{pieces[curr]} diff=#{diff}"
  Map.set_piece(rrow, pieces[curr])
  Map.draw_field(rrow, field)
end
