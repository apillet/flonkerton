class Actor
  attr_accessor :x, :y, :zorder, :scale_x, :scale_y, :color, :mode

  DEFAULTS = { :x       => 0,
               :y       => 0,
               :zorder  => 0,
               :scale   => 1,
               :color   => Gosu::Color::WHITE,
               :mode    => :default }

  def initialize options = {}
    options = DEFAULTS.merge(options)
    @x = options[:x]
    @y = options[:y]
    @zorder = options[:zorder]
    scale = options[:scale]
    @scale_x = options[:scale_x] || scale
    @scale_y = options[:scale_y] || scale
    @color = options[:color]
    @mode = options[:mode]
  end

  def scale= value
    @scale_x = value
    @scale_y = value
  end

  def image
    @image ||= Images[label]
  end

  def draw offset_x = 0, offset_y = 0
    image.draw :x => @x - offset_x,
               :y => @y - offset_y,
               :z => @zorder,
               :factor_x => @scale_x,
               :factor_y => @scale_y,
               :color => @color,
               :mode => @mode
  end

protected

  def label
    self.class.to_s[/\w+$/].scan(/([A-Z]+[a-z]+)/).flatten.join('_').downcase.intern
  end
end
