require '../lib/flonkerton'
require './extras/input_handler'
require './extras/fill'
require './extras/random_color'
include Gosu
include Flonkerton

module Example
  class Logo
    SPEED = 5
    
    def initialize x = 0, y = 0
      @image = Images[:gosu_logo]
      @x = x
      @y = y
    end

    def draw
      @image.draw :x => @x, :y => @y
    end

    def move_right; @x += SPEED; end
    def move_left;  @x -= SPEED; end
    def move_up;    @y -= SPEED; end
    def move_down;  @y += SPEED; end
  end

  class GameScreen < Screen
    include InputHandler
    include FillScreen

    def setup
      @color = Color::BLUE
      @font = Fonts[:default]
      @logo = Logo.new(20, 30)
      @input = { :up    => [KbUp, KbW],
                 :down  => [KbDown, KbS],
                 :left  => [KbLeft, KbA],
                 :right => [KbRight, KbD],
                 :color => [KbReturn, KbSpace, KbBackspace] }
    end

    def button_down(id)
      super # close
      @color = Color.random if pressed?(:color)
    end

    def update
      @logo.move_up    if pressed?(:up)
      @logo.move_down  if pressed?(:down)
      @logo.move_left  if pressed?(:left)
      @logo.move_right if pressed?(:right)
    end

    def draw
      fill @color
      @font.draw :text => 'Use WASD or Arrow Keys to move logo. SPACE to change color.', :x => 5, :y => 5
      @logo.draw
    end
  end
end

Game.start
