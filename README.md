iGEM Bricklayer
===============

Layin ma bricks!

### Note

The commands below are meant to be run in a terminal; which should be easy enough to access if you're using a mac or a linux distribution. Using Windows will be a little trickier. You'll have to install a terminal-like program.
The [Windows installer of Git](http://git-scm.com/downloads) comes with a terminal called git-bash. This should be enough to run these commands though you'll have to do some configuring so that the terminal is able to find the `node` program.

##### Alternatives:
* Install [Cygwin](http://www.cygwin.com/), another terminal like environment for windows.
* Install [Ubuntu](http://www.ubuntu.com/download), a linux distribution. Linux distributions are very programmer friendly and access to the terminal should be straightforward. You can choose to install it alongside you current operating system. 
* Get a [mac](http://www.apple.com/ca/macbook-air/).

### First Run

If this is your first run of the server, we have to make sure the dependencies are installed:

1. Install [node.js](http://nodejs.org/)! This will come with an executable called `npm` (Node Package Manager) that we'll use to install the dependencies.
2. Install `node-supervisor` with the command `npm install -g supervisor`. This supervisor app will automatically restart the server whenever a file in the project changes. Makes developping a little smoother.
3. If you're on Windows, install [MSYS](http://downloads.sourceforge.net/mingw/MSYS-1.0.11.exe) to a path without spaces. MSYS provides some unix tools like *make* and *bash*, which make development much easier. Make sure the MSYS tools are in your PATH. MSYS tools work with git.
3. Make sure you're in the same directory as `packages.json` and run the command `npm install`. This will install dependencies like express (our webserver), jade (an html template language), etc. into our project in the node_modules folder.

### Start App

To start the server run the command
`make go`

Visit http://localhost:3000/ in your browser to see the app.
See the `Makefile` to add more targets as you see fit.

### Some stuff to Read
* [Client-Server Model](https://en.wikipedia.org/wiki/Client%E2%80%93server_model)
* [Ajax Requests](http://en.wikipedia.org/wiki/Ajax_(programming)
* [Express Web Framework](http://expressjs.com/guide.html)
* [Coffeescript](http://coffeescript.org/)
* [Jade HTML Templating Language](http://jade-lang.com/)
* [Stylus CSS](http://learnboost.github.io/stylus/)
