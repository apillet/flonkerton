require '../lib/flonkerton'
include Flonkerton

module Example
  class GameScreen < Screen
    def setup
      @default = Fonts[:default]
      @arcade = Fonts[:arcade_classic]
    end

    def draw
      @arcade.draw :x => 10,
                   :text => 'Flonkerton',
                   :color => Gosu::Color::GREEN,
                   :factor_x => 2,
                   :factor_y => 2

      @default.draw :x => 30,
                    :y => 40,
                    :text => 'default font is ' + Gosu::default_font_name
    end
  end
end

Game.start
