require '../lib/flonkerton'
include Gosu
include Flonkerton

module Example
  class GameScreen < Screen
    
    INSTRUCTIONS = ['Press Escape to quit',
                    'Press Space to play Song',
                    'Press Backspace to stop Song',
                    'Press Enter to play Sample']

    def setup
      @font = Fonts[:default]
      @song = Songs[:catch_me_song]
      @beep = Samples[:select]
      @song.volume = 0.2
    end

    def button_down(id)
      super
      @song.play if id == KbSpace
      @song.stop if id == KbBackspace
      @beep.play if id == KbReturn
    end

    def draw
      write INSTRUCTIONS
    end

  protected

    def write list, left_margin = 5, top_margin = 0, space = 20
      list.each_with_index do |line, i|
        @font.draw :text => line,
                   :x    => left_margin,
                   :y    => top_margin + i * space
      end
    end
  end
end

Game.start
