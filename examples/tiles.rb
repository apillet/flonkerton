require '../lib/flonkerton'
include Flonkerton

module Example
  class GameScreen < Screen

    TILES = '.RWT' # Plain, Rock, Water, Tree

    MAP = ['.R...TTT',
           'RR....TT',
           '........',
           '....WWWW',
           '..WWWW..']

    def setup
      @tiles = Tiles[:tiles]
      @size = @tiles.first.width
    end

    def draw
      MAP.each_with_index do |line, y|
        line.split('').each_with_index do |char, x|
          @tiles[TILES.index(char)].draw :x => x * @size, :y => y * @size
        end
      end
    end
  end
end

Game.start
