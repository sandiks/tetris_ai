
require_relative  'helper'
require_relative  'black_box'

class Settings
  attr_accessor :timebank, :time_per_move, :your_bot, :field_width, :field_height
end

class Player
  attr_accessor :row_points, :combo, :field
end

class Map
  attr_accessor :field, :rr, :gaps, :w, :h

  def initialize
    @w=10
    @h=21

    @field 	= Array.new(@w+1) { ' '*@h }
    @rr 	= Array.new(@w+1,0)
    @gaps 	= Array.new(@w+1,0)

  end

  def parse_from(str)
    rows = str.split(';')
    h = rows.size
    rows.each do |rr|
      arr = rr.split(',')

      for x in 1..arr.size

        @field[x][h] = arr[x-1]
      end
      h=h-1
    end

    fill_rr
  end

  def fill_rr
    ff = @field

    for x in 1..@w
      @rr[x] = ff[x].rindex('2')
      @rr[x] = 1 if @rr[x].nil?
      @gaps[x] = ff[x].index('0')
      @gaps[x] = 0 if @gaps[x]>=@rr[x]
    end
  end

  def show
  	@field[1..@w].each{|r| p r.gsub('0',' ')}
  end
end

class Game
  attr_accessor :round, :this_piece_type, :next_piece_type, :time_left
  attr_accessor :map, :my, :other

  def initialize
    @map = Map.new
    @my = Player.new
    @other = Player.new
  end
end

