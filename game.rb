
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

    @field  = Array.new(@w+1) { '0'*@h }
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
      max2 = ff[i].rindex('2') #blocked cell
      max3 = ff[i].rindex('3')  #common cell
      max4 = ff[i].rindex('4')  #common cell
      @rr[i] = [max2,max3,max4].map { |e| e.to_i  }.max

      @gaps[i] = ff[i].rindex('0',@rr[i])
      @gaps[i] = 0 if @gaps[i].nil?
    end
  end
  def repl4
    ff = @field
    for i in 1..@w
      ff[i].gsub!('4','3')
    end
  end


  def fill_field_by_rr
    for i in 1..@w
      ff=@field[i]
      ff[0]='|'
      ff[1..@rr[i]] = '3'* @rr[i]
      ff[@gaps[i]]='0' if @gaps[i]>0
    end
  end

  def clone_field
    Marshal.load( Marshal.dump( @field ) )
  end

  def restore_field(ff)
    @field = ff
    fill_rr
  end

  def clean_lines
    ff=@field
    
    removed=[]
    min = rr[1..@w].min

    (1..min).each do |h|
      exist_gap = false
      for i in 1..10
        if ff[i][h]=='0'
          exist_gap = true
          #p "line with gaps h=#{h}"
          break
        end
      end

      if not exist_gap
        removed<<h
        for i in 1..10
          ff[i][h]='x'

        end
      end
    end

    for i in 1..10
      ff[i]=ff[i].gsub('x','').ljust(21,'0')
    end
    fill_rr
    removed
  end

  def show
    p "show field: 10x20"
    for i in 1..@w
      row =@field[i]
      row[0]='|'
      p "#{row.gsub('0',' ')}| rr=#{@rr[i]} gg=#{@gaps[i]}"
    end
  end

end
