module Scrollable
  class Viewport

    DEFAULTS = { :x          => 0,
                 :y          => 0,
                 :width      => 800,
                 :height     => 600,
                 :max_width  => 1600,
                 :max_height => 1200,
                 :speed      => 5 }

    attr_reader :width, :height
    attr_accessor :x, :y, :speed, :max_width, :max_height

    def initialize options = {}
      options = DEFAULTS.merge(options)
      @x = options[:x]
      @y = options[:y]
      @speed = options[:speed]
      @width = options[:width]
      @height = options[:height]
      @max_width = options[:max_width]
      @max_height = options[:max_height]
    end

    def move_left
      @x -= @speed if left_allowed?
    end

    def move_right
      @x += @speed if right_allowed?
    end

    def move_up
      @y -= @speed if up_allowed?
    end

    def move_down
      @y += @speed if down_allowed?
    end

  protected

    def left_allowed?
      @x >= @speed
    end

    def right_allowed?
      @x + @width + @speed <= @max_width
    end

    def down_allowed?
      @y + @height + @speed <= @max_height
    end

    def up_allowed?
      @y >= @speed
    end
  end

  def viewport
    @viewport ||= Viewport.new
  end

  def scroll_down
    viewport.move_down
  end

  def scroll_up
    viewport.move_up
  end

  def scroll_left
    viewport.move_left
  end

  def scroll_right
    viewport.move_right
  end
end
