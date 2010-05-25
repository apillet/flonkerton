require '../../lib/flonkerton'
require '../../examples/extras/random_color'
include Flonkerton
include Gosu

module GosuTutorial
  module ZOrder
    Background, Stars, Player, UI = *0..3
  end

  class Player
    attr_reader :score

    def initialize
      @image = Images[:starfighter]
      @beep = Samples[:beep]
      @x = @y = @vel_x = @vel_y = @angle = 0.0
      @score = 0
    end

    def warp(x, y)
      @x, @y = x, y
    end

    def turn_left
      @angle -= 4.5
    end

    def turn_right
      @angle += 4.5
    end

    def accelerate
      @vel_x += Gosu::offset_x(@angle, 0.5)
      @vel_y += Gosu::offset_y(@angle, 0.5)
    end

    def move
      @x += @vel_x
      @y += @vel_y
      @x %= CONFIG[:width]
      @y %= CONFIG[:height]

      @vel_x *= 0.95
      @vel_y *= 0.95
    end

    def draw
      @image.draw_rot(@x, @y, ZOrder::Player, @angle)
    end

    def collect_stars(stars)
      stars.reject! do |star|
        if Gosu::distance(@x, @y, star.x, star.y) < 35 then
          @score += 10
          @beep.play
          true
        else
          false
        end
      end
    end
  end

  class Star
    attr_reader :x, :y

    def initialize
      @animation = Tiles[:star]
      @offset = @animation.first.width / 2.0
      @color = Color.random((40..254), (40..254), (40..254))
      @x = rand * CONFIG[:width]
      @y = rand * CONFIG[:height]
    end

    def draw
      current_frame.draw :x => @x - @offset,
                         :y => @y - @offset,
                         :z => ZOrder::Stars,
                         :color => @color,
                         :mode => :additive
    end

  protected
  
    def current_frame
      @animation[Gosu::milliseconds / 100 % @animation.size]
    end
  end

  class GameScreen < Screen
    def setup
      @background = Images[:space]
      @player = Player.new
      @player.warp(320, 240)      
      @stars = Array.new
      @font = Fonts[:default]
      @input = { :up    => [KbUp, GpButton0],
                 :left  => [KbLeft, GpLeft],
                 :right => [KbRight, GpRight] }
    end

    def update
      @player.turn_left  if pressed?(:left)
      @player.turn_right if pressed?(:right)
      @player.accelerate if pressed?(:up)
      @player.move
      @player.collect_stars(@stars)

      if rand(100) < 4 and @stars.size < 25 then
        @stars << Star.new
      end
    end

    def draw
      @background.draw
      @player.draw
      @stars.each { |star| star.draw }
      @font.draw :text => "Score: #{@player.score}",
                 :x => 10,
                 :y => 10,
                 :z => ZOrder::UI,
                 :color => Color::YELLOW
    end

  protected

    # Taken from control example.
    def pressed?(key)
      @input[key].detect { |k| @game.button_down?(k) }
    end
  end
end

Game.start