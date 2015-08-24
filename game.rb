
require_relative  'helper'


class Settings
  attr_accessor :timebank, :time_per_move, :your_bot, :field_width, :field_height
end

class Player
  attr_accessor :row_points, :combo, :field
end

class Game
  attr_accessor :round, :this_piece_type, :next_piece_type, :this_piece_position, :time_left
  attr_accessor :map, :my, :other

  def initialize
    @map = Map.new
    @my = Player.new
    @other = Player.new
  end
end

class Map
  attr_accessor :field, :rr, :gaps, :w, :h, :best_curr_pos, :curr_piece, :next_piece

  def initialize(w=10 , h=21)
    @w=w
    @h=h

    @field  = Array.new(@w+1) { ' '*@h }
    @rr   = Array.new(@w+1,0)
    @gaps   = Array.new(@w+1,0)

  end

  def parse_from(str)
    rows = str.split(';')
    h = rows.size
    rows.each do |rr|
      arr = rr.split(',')

      for i in 1..arr.size

        @field[i][h] = arr[i-1]
      end
      h -=1
    end

    fill_rr
  end

  def fill_rr
    ff = @field

    for i in 1..@w
      @rr[i] = ff[i].rindex('2')
      @rr[i] = ff[i].rindex('3') if @rr[i].nil?
      @rr[i] = 0 if @rr[i].nil?
      
      @gaps[i] = ff[i].rindex('0',@rr[i])
      @gaps[i] = 0 if @gaps[i].nil?
    end
  end

  def show
    for i in 1..@w
      row =@field[i]
      row[0]='|'
      p "#{row.gsub('0',' ')}| rr=#{@rr[i]}"
    end
  end
end
