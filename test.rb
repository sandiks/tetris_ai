
require_relative  'map'



ptype = 'S'
p "rules"
p load_rules(ptype)

mm = Map.new


8.times do
  MapPrinter.detect_position(mm, ptype)
  p "gaps #{mm.gaps}"
  MapPrinter.draw_field(mm)
end
