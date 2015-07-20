
require_relative  'map'
require_relative  'helper'

mm = Map.new


pieces = ['I','J','L','O','S','Z','T']


12.times do
  curr = rand(7)
  diff = mm.rr.max - mm.rr.min
  p "rand=#{curr} type=#{pieces[curr]} diff=#{diff}"
  MapPrinter.detect_position(mm, pieces[curr])
  MapPrinter.draw_field(mm)
end
