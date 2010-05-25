require '../lib/flonkerton'
include Flonkerton

module Example
  class GameScreen < Screen
    def setup
      @background = Images[:background]
    end

    def draw
      clip_to(10, 10, 320, 200) { @background.draw }
    end
  end
end

Game.start
