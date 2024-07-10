#!/bin/sh

set -v

case "$(uname -s)" in
    Darwin)
        if command -v brew >/dev/null; then
	    echo "Detected macOS. Installing dependencies with brew."
	    sudo=""

	    brew install sdl2
	    brew install sdl2_mixer
	    brew install sdl2_ttf
	    brew install sdl2_image
	    brew install sdl2_gfx
        else
            echo "Detected macOS but not brew. Install Homebrew and try again."
            exit 1
        fi
	;;
    Linux)
        if command -v apt >/dev/null; then
            echo "Detected Linux. Installing dependencies with apt."
            sudo="sudo"

            $sudo apt-get install --no-install-recommends --no-install-suggests libsdl1.2-dev libsdl-image1.2-dev libsdl-mixer1.2-dev libsdl-ttf2.0-dev gcc g++
        else
            echo "Detected macOS but not apt. Install sdl2 with your package manager."
            exit 1
        fi
        ;;
    *)
        echo "Dependency installation not supported for your OS. Install sdl2 with your package manager."
        exit 1
	;;
esac

if [ -f "$0" ]; then
    $sudo gem install hoe --conservative
    $sudo rake newb
    rake test
    rake clean package
    $sudo gem install pkg/graphics*.gem
else
    $sudo gem install graphics
fi

echo "Running a graphics test... You should see a window appear."
ruby -Ilib -rgraphics -e 'Class.new(Graphics::Simulation) { def draw n; clear :white; text "hit escape to quit", 100, 100, :black; end; }.new(500, 250, "Working!").run'
