# Flonkerton

Gosu toys for the bored rubyist.

## Requisites

You'll need [Gosu](http://www.libgosu.org/).

Also [Protest](http://github.com/matflores/protest), [RR](http://github.com/btakita/rr) and [Watchr](http://github.com/mynyml/watchr) for test awesomeness.

## Installation

    $ sudo gem install flonkerton

## Features

* Screens Handling
* Auto-loads Resources
* YAML Configuration
* Some conventions and default values

## Usage

    require 'flonkerton'
    Flonkerton::Game.start

### Hello World

    require 'flonkerton'
    include Flonkerton

    class HelloWorld < Screen
      def draw
        Fonts[:default].draw(:text => 'Hello World!')
      end
    end

    Game.start(HelloWorld)

### Basic Example

    require 'flonkerton'
    include Flonkerton

    class GameScreen < Screen
      def setup
        @x = 0
        @song = Songs[:intro]
        @image = Images[:gosu_logo]
        @sample = Samples[:beep]
      end

      def button_down(id)
        close        if id == Gosu::KbEscape # or super
        @song.play   if id == Gosu::KbSpace
        @sample.play if id == Gosu::KbReturn
      end

      def update
        @x += 10 if button_down?(Gosu::KbRight)
      end

      def draw
        @image.draw(:x => @x)
      end
    end

    Game.start(GameScreen)

See [examples](/apillet/flonkerton/tree/master/examples/).

## Related Projects

* [Chingu](http://github.com/ippa/chingu)
* [Compote](http://github.com/HakubJozak/compote)
* [Exuberant](http://github.com/adamsanderson/lexery/tree/master/lib/exuberant)
* [FWD](http://github.com/walski/FWD)
* [Gosu Extensions](http://github.com/floere/gosu_extensions)
* [Grandpa](http://github.com/arirusso/grandpa)
* [Lotu](http://github.com/lobo-tuerto/lotu)
* [Nimo](http://github.com/moonpxi/nimo)
* [PuitUniverse](http://github.com/oneup/puituniverse)
* [Ramverk](http://github.com/deps/Ramverk)
* [Space Shooter Engine](http://github.com/belen-albeza/space-shooter/tree/master/engine/)
* [SpriteJam](http://github.com/richardeden/spritejam)
* [UrDoinItRite](http://github.com/actsasbuffoon/UrDoinItRite)

The following projects are not based on Gosu, but worth looking into:

* [Ruby Warrior](http://github.com/ryanb/ruby-warrior)
* [Gamebox](http://github.com/shawn42/gamebox)
* [Jemini](http://github.com/jemini/jemini-core)
* [Zyps](http://github.com/jaymcgavren/zyps)

## License

Copyright (c) 2010 Ariel H. Pillet

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
