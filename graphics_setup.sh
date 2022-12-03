#!/bin/sh

set -v

case `uname` in
    Darwin)
	echo "I'm on OSX. Not using sudo"
	SUDO=

	brew install sdl2
	brew install sdl2_mixer
	brew install sdl2_ttf
	brew install sdl2_image
        brew install sdl2_gfx
	;;
    Linux)
	echo "I'm on linux, using sudo where needed"
	SUDO=sudo

	$SUDO apt-get install --no-install-recommends --no-install-suggests libsdl1.2-dev libsdl-image1.2-dev libsdl-mixer1.2-dev libsdl-ttf2.0-dev gcc g++
	;;
    *)
	echo "Unknown OS $OSTYPE, aborting"
	exit 1
	;;
esac

if [ -f $0 ]; then
    $SUDO gem update --system -N -V
    $SUDO gem install hoe --conservative
    $SUDO rake newb
    rake test
    rake clean package
    $SUDO gem install pkg/graphics*.gem
else
    $SUDO gem install graphics
fi

echo "running a test... you should see a window show up."
ruby -Ilib -rgraphics -e 'Class.new(Graphics::Simulation) { def draw n; clear :white; text "hit escape to quit", 100, 100, :black; end; }.new(500, 250, "Working!").run'
