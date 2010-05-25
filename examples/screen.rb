require '../lib/flonkerton'
require 'extras/fill'
include Gosu
include Flonkerton

module Example
  class LogoScreen < Screen
    def draw
      Fonts[:default].draw :text => 'LOGO SCREEN - press Space', 
                           :x => 10,
                           :y => 10
    end

    def button_down(id)
      super # close
      go_to(GameScreen) if id == KbSpace
    end
  end

  class GameScreen < Screen
    include FillScreen
    
    def draw
      fill
      Fonts[:default].draw :text => 'GAME SCREEN - press Space',
                           :color => Color::BLACK,
                           :x => 10,
                           :y => 10
    end
    
    def button_down(id)
      super # close
      go_to(LogoScreen) if id == KbSpace
    end
  end
end

Game.start(Example::LogoScreen)
