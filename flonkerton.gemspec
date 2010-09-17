Gem::Specification.new do |s|
  s.name              = "flonkerton"
  s.version           = "0.0.2"
  s.summary           = "Gosu toys for the bored rubyist."
  s.description       = "A simple framework that aims to improve your Gosu experience."
  s.authors           = ["Ariel H. Pillet"]
  s.email             = ["apillet@gmail.com"]
  s.homepage          = "http://github.com/apillet/flonkerton"
  s.files = ["TODO", "README.md", "media/CREDITS", "Rakefile", "watchmen.rb", "config/defaults.yml", "examples/clip.rb", "examples/config/defaults.yml", "examples/extras/actor.rb", "examples/extras/fill.rb", "examples/extras/input_handler.rb", "examples/extras/mouse_border.rb", "examples/extras/random_color.rb", "examples/extras/scrollable.rb", "examples/font.rb", "examples/input.rb", "examples/screen.rb", "examples/scroll.rb", "examples/sound.rb", "examples/tiles.rb", "games/gosu_demo/config/defaults.yml", "games/gosu_demo/media/beep.wav", "games/gosu_demo/media/Space.png", "games/gosu_demo/media/star_25x25.png", "games/gosu_demo/media/starfighter.png", "games/gosu_demo/original.rb", "games/gosu_demo/play.rb", "lib/flonkerton.rb", "flonkerton.gemspec", "media/ArcadeClassic.ttf", "media/background.png", "media/catch_me_song.ogg", "media/cursor.png", "media/gosu_logo.png", "media/select.wav", "media/tiles_32x32.png", "test/integration_test.rb", "test/test_helper.rb", "test/unit_tests.rb"]

  s.rubyforge_project = "flonkerton"
  s.add_dependency "gosu", ">= 0.7.19"
  s.add_development_dependency "protest", ">= 0.4.1"
  s.add_development_dependency "override", ">= 0.0.10"
  s.add_development_dependency "watchr", ">= 0.6"
end
