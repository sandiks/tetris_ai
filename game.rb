
require_relative  'helper'


class Settings
  attr_accessor :timebank, :time_per_move, :your_bot, :field_width, :field_height
end

class Player
  attr_accessor :row_points, :combo, :field
  def initialize
    @combo=0
  end
end

class Game
  attr_accessor :round, :this_piece_type, :next_piece_type, :this_piece_position, :time_left
  attr_accessor :map, :my, :other
  attr_accessor :log

  def initialize
    @map = Map.new
    @my = Player.new
    @other = Player.new
    @log=[]
    @round=0
  end

  def need_force_mode?
    map2 = Map.new

    if not @other.field.nil?
      map2.parse_from(@other.field)
      rr2 = map2.rr[1..-1]
      max2 = rr2.max
      min2 = rr2.min

      opp = max2-min2<12 || min2>7
    else
      opp = true
    end

    ###my

    rr = @map.rr[1..-1]
    max = rr.max
    min = rr.min
    my= max-min<12 && max<16 && min<6 && @my.combo<1

    #detect force mode
    opp && my
  end
end

class Map
  attr_accessor :field,:nice_field, :rr, :gaps, :w, :h
  attr_accessor :curr_piece, :next_piece, :combo, :force_mode

  def initialize(w=10 , h=21)
    @w=w
    @h=h

    @field  = Array.new(@w+1) { '0'*@h }
    @rr   = Array.new(@w+1,0)
    @gaps   = Array.new(@w+1,0)
    @combo=0
    @force_mode = false

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
      ff[i].gsub!('4','2')
    end
  end


  def fill_field_by_rr
    for i in 1..@w
      ff=@field[i]
      ff[0]='|'
      ff[1..@rr[i]] = '2'* @rr[i]
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

  def start_force_mode
    @force_mode = true

    @w =8
    @rr   = Array.new(@w+1,0)
    @gaps   = Array.new(@w+1,0)
    fill_field_by_rr
  end

  def clean_lines
    ff=@field

    removed=[]
    min = rr[1..@w].min

    (1..min).each do |h|
      need_leave = false
      for i in 1..@w
        if ff[i][h]=='0' || ff[i][h]=='3'
          need_leave = true
          #p "line with gaps h=#{h}"
          break
        end
      end

      if not need_leave
        removed<<h
        for i in 1..@w
          ff[i][h]='x'

        end
      end
    end
    @nice_field = clone_field

    for i in 1..@w
      ff[i]=ff[i].gsub('x','').ljust(21,'0')
    end
    fill_rr
    removed
  end

  def show
    p "show field: combo:#{@combo} force:#{force_mode} curr:#{@curr_piece} next:#{next_piece}"
    for i in 1..@w
      row =@nice_field[i]
      row[0]='|'
      ind = "#{i}".ljust(2,' ')
      p "#{ind}#{row.gsub('0',' ')}| rr=#{@rr[i]} gg=#{@gaps[i]}"
    end
  end

end
