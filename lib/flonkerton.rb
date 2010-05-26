require 'gosu'
require 'yaml'

class File
  def self.label(file)
    self.basename(file)[/^\w+/].scan(/[A-Z]*[a-z0-9]+/).join('_').downcase.intern
  end
end

module Flonkerton
  VERSION = '0.0.1'
  LIB_PATH = File.dirname(File.expand_path(__FILE__))
  CURRENT_PATH = File.dirname(File.expand_path($0))

  if File.exist?(CURRENT_PATH + '/config/defaults.yml')
    CONFIG = YAML.load_file(CURRENT_PATH + '/config/defaults.yml')
  else
    CONFIG = YAML.load_file(LIB_PATH + '/../config/defaults.yml')
  end

  module Drawable
    def draw(options = {})
      super(*draw_args(defaults.merge(options)))
    end

  protected
  
    def draw_args(options)
      defaults[:order].map { |arg| options[arg] } # 1.8.6 Patch - defaults.keys.map in 1.9
    end

    def name
      self.class.to_s[/\w+$/].downcase
    end

    def defaults
      CONFIG[name.intern]
    end
  end

  class Font < Gosu::Font
    include Drawable

    def initialize(game, name, height = CONFIG[:font_size])
      super(game, name, height)
    end
  end

  class Image < Gosu::Image
    include Drawable

    def self.load_tiles(game, file, width, height, border = true)
      super(game, file, width, height, border).each do |image|
        image.extend(Drawable)
      end
    end
  end

  class Sample < Gosu::Sample; end

  class Song < Gosu::Song
    def loop
      play(true)
    end
  end

  # This class shouldn't be used directly, it provides behavior for subclasses.
  #
  class Resource
    def self.load(game)
      Dir[path].each do |file|
        all[File.label(file)] = klass.new(game, file)
      end
    end

    def self.all
      @hash ||= Hash.new
    end

    def self.[](key)
      all[key]
    end

  protected

    def self.name
      self.to_s[/\w+$/]
    end

    def self.klass
      Module.class_eval(name.chop)
    end

    def self.path
      File.join(CONFIG[:media_path], extension)
    end

    def self.extension
      CONFIG["#{name.downcase}_ext".intern]
    end
  end

  class Songs < Resource; end
  class Images < Resource; end
  class Samples < Resource; end

  class Fonts < Resource
    def self.load(game)
      super(game)
      all[:default] = Font.new(game, Gosu::default_font_name)
    end
  end

  class Tiles < Resource
    def self.load(game)
      Dir[path].each do |file|
        if File.basename(file) =~ /(\w+)_(\d+)x(\d+)/
          all[$1.intern] = Image.load_tiles(game, file, $2.to_i, $3.to_i, true)
        end
      end
    end
  end

  class Game
    def self.start screen = nil
      @window = Window.new(screen)
      @window.show
    end
  end

  class Window < Gosu::Window
    attr_reader :screen
    attr_accessor :next_screen

    def initialize initial_screen = nil
      super(CONFIG[:width], CONFIG[:height], CONFIG[:fullscreen])
      self.caption = CONFIG[:caption]
      load_resources
      create(initial_screen || default_screen)
    end

    def update
      @screen.update
      create(@next_screen) if @next_screen
    end

    def draw
      @screen.draw
    end

    def button_down(id)
      @screen.button_down(id)
    end

    def button_up(id)
      @screen.button_up(id)
    end

    def params
      @params ||= Hash.new
    end

  protected

    def load_resources
      [Fonts, Songs, Images, Samples, Tiles].each do |resource|
        resource.load(self)
      end
    end

    def default_screen
      Module.module_eval(CONFIG[:initial_screen])
    end

    def create(klass)
      @screen = klass.new(self)
      @next_screen = nil
    end
  end

  # This class shouldn't be instantiated, it provides behavior for subclasses.
  #
  class Screen
    def initialize game
      @game = game
      setup
    end
    
    def setup; end
    def button_up(id); end    

    def button_down(id)
      close if id == Gosu::KbEscape # Don't Panic!
    end

    def update; end
    def draw; end

    def width
      @game.width
    end

    def height
      @game.height
    end

    def mouse_x
      @game.mouse_x
    end

    def mouse_y
      @game.mouse_y
    end

    def button_down?(id)
      @game.button_down?(id)
    end

    def close
      @game.close
    end

    def go_to(screen)
      @game.next_screen = screen
    end

    def params
      @game.params
    end

    def clip_to(x, y, w, h, &block)
      @game.clip_to(x, y, w, h, &block)
    end
  end

  class WelcomeScreen < Screen
    def draw
      Fonts[:default].draw :text => 'Welcome'
    end
  end
end
