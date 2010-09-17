require File.expand_path(File.dirname(__FILE__) + '/test_helper.rb')

class Protest::TestCase
  def window
    @@window ||= Flonkerton::Window.new
  end
end

Protest.describe('Flonkerton') do
  it 'has a CONFIG hash.' do
    config = { :width => 800,
               :height => 600,
               :caption => "Flonkerton Example",
               :fullscreen => false,
               :font_size => 20,
               :initial_screen => "WelcomeScreen",
               :media_path => "media",
               :songs_ext => "*.ogg",
               :images_ext => "*.png",
               :samples_ext => "*.wav",
               :tiles_ext => "*.png",
               :fonts_ext => "*.ttf",
               :image => { :x => 0,
                           :y => 0,
                           :z => 0,
                           :factor_x => 1,
                           :factor_y => 1,
                           :color => 0xffffffff,
                           :mode => :default,
                           :order => [:x, :y, :z, :factor_x, :factor_y, :color, :mode] },
               :font => { :text => "",
                          :x => 0,
                          :y => 0,
                          :z => 0,
                          :factor_x => 1,
                          :factor_y => 1,
                          :color => 0xffffffff,
                          :mode => :default,
                          :order => [:text, :x, :y, :z, :factor_x, :factor_y, :color, :mode] } }

    assert_equal config, Flonkerton::CONFIG
  end
end

Protest.describe('A Game Window') do
  it 'has a current screen. (default: WelcomeScreen)' do
    assert window.screen.is_a?(Flonkerton::WelcomeScreen)
  end

  it 'has a next screen. (default: nil)' do
    assert window.next_screen.nil?
  end

  context('when running') do
    module Example
      class LogoScreen < Flonkerton::Screen
        def setup
          params[:log] = Array.new
        end

        def button_down(id)
          params[:log] << 'press'
        end

        def button_up(id)
          params[:log] << 'release'
        end

        def update
          params[:log] << 'update'
        end

        def draw
          params[:log] << 'draw'
          go_to(GameScreen)
        end
      end
      class GameScreen < Flonkerton::Screen
        def setup
          params[:log] << 'new screen'
        end
      end
    end

    setup do
      window.next_screen = Example::LogoScreen
      window.update
    end

    it 'draw and update the current screen.' do
      assert window.params[:log].empty?

      # Fake a Gosu::Window.show loop iteration
      #
      window.button_down(Gosu::KbSpace)
      window.button_up(Gosu::KbSpace)
      window.update
      window.draw

      result = {:log => ['press', 'release', 'update', 'draw']}
      assert_equal result, window.params

      # Change screen on next tick
      window.update

      assert window.params[:log].include?('new screen')
    end

    after do
      window.params.clear
    end
  end

  it 'has a params hash.' do
    assert_equal Hash.new, window.params
  end
end

Protest.describe('A Screen') do
  setup do
    @screen = Flonkerton::Screen.new(window)
  end

  # Gosu::Window methods
  #
  it 'has a width.' do
    assert_equal 800, @screen.width
  end

  it 'has a height.' do
    assert_equal 600, @screen.height
  end

  it 'has mouse coordinates.' do
    assert @screen.mouse_x.is_a?(Numeric)
    assert @screen.mouse_y.is_a?(Numeric)
  end

  it 'closes itself when Escape is pressed.' do
    override(@screen, :close => lambda { params[:close] = true })

    assert @screen.params.empty?
    @screen.button_down(Gosu::KbEscape)
    assert !@screen.params.empty?
  end

  it 'knows if a button is down.' do
    override(window, :button_down? => lambda {|id| id == Gosu::KbA })
    assert @screen.button_down?(Gosu::KbA)
    assert !@screen.button_down?(Gosu::KbZ)
  end

  # Empty methods to override.
  #
  it 'can setup before game loop.' do
    assert @screen.respond_to?(:setup)
  end

  it 'check button_up events while in game loop.' do
    assert @screen.respond_to?(:button_up)
  end

  it 'updates game logic while in game loop.' do
    assert @screen.respond_to?(:update)
  end

  it 'draws while in game loop.' do
    assert @screen.respond_to?(:draw)
  end

  it 'shares a params hash with other screens.' do
    module Example
      class LogoScreen < Flonkerton::Screen
        def setup
          params[:foo] = 200
        end
        def update
          go_to(GameScreen)
        end
      end
      class GameScreen < Flonkerton::Screen
        def setup
          params[:bar] = 'abc' + params[:foo].to_s
        end
        def update
          close
        end
      end
    end

    @game = Flonkerton::Window.new(Example::LogoScreen)
    @game.update
    assert_equal 200, @game.params[:foo]
    assert_equal 'abc200', @game.params[:bar]
  end

  it 'can close itself.' do
    assert @screen.respond_to?(:close) # ...
  end

  it 'can clip an image.' do
    assert @screen.respond_to?(:clip_to) # ...
  end

  it 'calls setup method after initialization.' do
    module Example
      class LogoScreen < Flonkerton::Screen
        attr_reader :value
        def setup
          @value = 100
        end
      end
    end
    assert_equal 100, Example::LogoScreen.new(@game).value
  end
end

Protest.describe('A WelcomeScreen') do
  module DrawLog
    def data
      @data ||= []
    end

    def draw options = {}
      data << options[:text]
    end

    def wrote? text
      data.include? text
    end
  end
  Flonkerton::Font.send(:include, DrawLog)

  setup do
    @welcome_screen = Flonkerton::WelcomeScreen.new(window)
  end

  it 'shows a brief explanation about Flonkerton.' do
    font = Flonkerton::Fonts[:default]
    assert !font.wrote?('Welcome')
    @welcome_screen.draw
    assert font.wrote?('Welcome')
  end
end

Protest.describe('A Sample') do
  setup do
    @sample = Flonkerton::Sample.new(window, 'media/select.wav')
  end

  it 'is a Gosu::Sample.' do
    assert @sample.is_a?(Gosu::Sample)
  end
end

Protest.describe('A Song') do
  setup do
    @song = Flonkerton::Song.new(window, 'media/catch_me_song.ogg')
  end

  it 'is a Gosu::Song.' do
    assert @song.is_a?(Gosu::Song)
  end

  it 'has a loop method.' do
    assert @song.respond_to?(:loop) # ...
  end
end

Protest.describe('A Font') do
  setup do
    @font = Flonkerton::Font.new(window, 'media/ArcadeClassic.ttf')
  end

  it 'is a Gosu::Font.' do
    assert @font.is_a?(Gosu::Font)
  end

  it 'has a draw method that takes an options hash.' do
    @font.draw :text => 'test', :color => Gosu::Color::RED
  end
end

Protest.describe('An Image') do
  setup do
    @image = Flonkerton::Image.new(window, 'media/gosu_logo.png')
  end

  it 'is a Gosu::Image.' do
    assert @image.is_a?(Gosu::Image)
  end

  it 'has a draw method that takes an options hash.' do
    @image.draw :x => 20, :mode => :additive
  end
end

Protest.describe('Resource') do
  it 'returns the content hash' do
    assert_equal Hash.new, Flonkerton::Resource.all
  end
end

Protest.describe('Resource - Fonts') do
  it 'has a :default font.' do
    assert Flonkerton::Fonts[:default].is_a?(Flonkerton::Font)
  end

  it 'loads all fonts in CONFIG[:media_path].' do
    path = File.join(Flonkerton::CONFIG[:media_path], Flonkerton::CONFIG[:fonts_ext])
    files = Dir[path]
    assert files.any?
    fonts = [Flonkerton::Fonts[:default]]
    files.each do |file|
      fonts << Flonkerton::Fonts[File.label(file)]
    end
    assert_equal fonts.uniq.map {|x| x.class }, Array.new(files.size + 1, Flonkerton::Font)
  end
end

Protest.describe('Resource - Images') do
  it 'loads all images in CONFIG[:media_path].' do
    path = File.join(Flonkerton::CONFIG[:media_path], Flonkerton::CONFIG[:images_ext])
    files = Dir[path]
    assert files.any?
    images = []
    files.each do |file|
      images << Flonkerton::Images[File.label(file)]
    end
    assert_equal images.uniq.map {|x| x.class }, Array.new(files.size, Flonkerton::Image)
  end
end

Protest.describe('Resource - Songs') do
  it 'loads all songs in CONFIG[:media_path].' do
    path = File.join(Flonkerton::CONFIG[:media_path], Flonkerton::CONFIG[:songs_ext])
    files = Dir[path]
    assert files.any?
    songs = []
    files.each do |file|
      songs << Flonkerton::Songs[File.label(file)]
    end
    assert_equal songs.uniq.map {|x| x.class }, Array.new(files.size, Flonkerton::Song)
  end
end

Protest.describe('Resource - Samples') do
  it 'loads all samples in CONFIG[:media_path].' do
    path = File.join(Flonkerton::CONFIG[:media_path], Flonkerton::CONFIG[:samples_ext])
    files = Dir[path]
    assert files.any?
    samples = []
    files.each do |file|
      samples << Flonkerton::Samples[File.label(file)]
    end
    assert_equal samples.uniq.map {|x| x.class }, Array.new(files.size, Flonkerton::Sample)
  end
end

Protest.describe('Resource - Tiles') do
  it 'loads all images in CONFIG[:media_path] that looks like a tileset. (eg. woods_64x64.png)' do
    path = File.join(Flonkerton::CONFIG[:media_path], Flonkerton::CONFIG[:tiles_ext])
    files = Dir[path]
    assert files.any?
    tiles = []
    files.each do |file|
      if File.basename(file) =~ /(\w+)_(\d+)x(\d+)/
        tiles << Flonkerton::Tiles[$1.intern]
      end
    end
    assert_equal tiles.uniq.map {|x| x.class }, Array.new(tiles.size, Array)

    # returns Gosu::Image
    image = tiles.first.first
    assert image.is_a?(Gosu::Image)

    # ..but draw takes a hash, same as Flonkerton::Image
    image.draw :x => 20, :mode => :additive
  end
end

Protest.describe('File') do
  context('.label') do
    it 'returns a symbol for an specific file' do
      assert_equal :gosu_logo, File.label('media/gosu_logo.png')
    end
  end
end
