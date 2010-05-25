require '../lib/flonkerton'
require 'extras/actor'
require 'extras/mouse_border'
require 'extras/scrollable'
require 'extras/input_handler'
require 'extras/random_color'

include Gosu
include Flonkerton

module Example
  Background = Class.new(Actor)
  GosuLogo = Class.new(Actor)

  class GameScreen < Screen
    include Scrollable
    include MouseBorder
    include InputHandler
    
    def setup
      # Resources
      @font = Fonts[:default]
      @mouse = Images[:cursor]

      # Configure InputHandler
      @input = { :left  => [KbA, KbLeft, GpLeft],
                 :right => [KbD, KbRight, GpRight],
                 :up    => [KbW, KbUp, GpUp],
                 :down  => [KbS, KbDown, GpDown] }

      # Actors
      @background = Background.new :scale => 2
      @things = Array.new
      100.times do
        @things << GosuLogo.new(:x => rand(width * 2),
                                :y => rand(height * 2),
                                :scale => [0.2, 0.4, 0.6, 0.8, 1].sample,
                                :color => Color.random,
                                :mode  => [:default, :additive].sample)
      end
    end

    def update
      # Uses Scrollable, MouseBorder and InputHandler
      scroll_right if mouse_on_right?  or pressed?(:right)
      scroll_left  if mouse_on_left?   or pressed?(:left)
      scroll_up    if mouse_on_top?    or pressed?(:up)
      scroll_down  if mouse_on_bottom? or pressed?(:down)

      # Random Game Logic
      20.times do
        npc = @things.sample
        npc.x += (-5..5).rand
        npc.y += (-5..5).rand
      end
    end

    def draw
      # Actors receives viewport coordinates.
      @background.draw(@viewport.x, @viewport.y)
      @things.each do |thing|
        thing.draw(@viewport.x, @viewport.y)
      end

      # Resources receives screen coordinates.
      @mouse.draw :x => mouse_x, :y => mouse_y
      @font.draw :text => 'Use Mouse, WASD or Arrow Keys to scroll...', :x => 5, :y => 5
    end
  end
end

Game.start
