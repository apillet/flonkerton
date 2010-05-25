require File.dirname(__FILE__) + '/test_helper.rb'

Protest.context('A Game example') do
  module Example
    class TextLogo

      SPEED_X = 16
      SPEED_Y = 10

      def initialize text, limit
        @text = text
        @limit = limit
        @font = Flonkerton::Fonts[:default]
        @x = 0
        @y = 0
      end

      def update
        @x += SPEED_X
        @y += SPEED_Y
      end

      def draw
        @font.draw :text => @text,
                   :x => @x,
                   :y => @y,
                   :factor_x => 4,
                   :factor_y => 4
      end

      def on_screen?
        @y < @limit
      end
    end

    class LogoScreen < Flonkerton::Screen
      LOGO_TIME = 1000

      def setup
        @time = Gosu.milliseconds
        @font = Flonkerton::Fonts[:default]
        @image = Flonkerton::Images[:gosu_logo]
        @sample = Flonkerton::Samples[:select]
        @x = (width - @image.width) / 2
        @y = (height - @image.height) / 2
        @song = Flonkerton::Songs[:catch_me_song]
        @song.volume = 0.1
        @song.loop
      end

      def update
        if time_elapsed? or button_down?(Gosu::KbReturn)
          @song.play
          @sample.play
          params[:health] = 75
          go_to(GameScreen)
        end
      end

      def draw
        fill
        @image.draw :x => @x, :y => @y

        @font.draw :x => 10,
                   :y => height - @font.height,
                   :text => 'Press Enter to continue...',
                   :color => Gosu::Color::BLACK

        @font.draw :text  => time_left,
                   :color => Gosu::Color::BLACK
      end

      def fill(color = 0xffffffff)
        @game.draw_quad(0, 0, color, width, 0, color, 0, height, color, width, height, color)
      end

      def time_left
        Gosu.milliseconds - @time
      end

      def time_elapsed?
        time_left >= LOGO_TIME
      end
    end

    class GameScreen < Flonkerton::Screen
      def setup
        @logo = TextLogo.new('LOGO', height)        
        @mouse = Flonkerton::Images[:cursor]
        @tiles = Flonkerton::Tiles[:tiles]
        @background = Flonkerton::Images[:background]
      end

      def draw
        @tiles.first.draw
        clip_to(40, 40, 640, 480) do
          @background.draw
        end
        @logo.draw
        @mouse.draw :x => mouse_x, :y => mouse_y
      end

      def update
        @logo.update
        close unless @logo.on_screen?
      end
    end
  end

  it "should work." do
    assert_nothing_raised do
      Flonkerton::Game.start(Example::LogoScreen)
    end
  end
end
