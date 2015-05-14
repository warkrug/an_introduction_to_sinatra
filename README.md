An Introduction to Sinatra
==========================

Sinatra is a DSL for quickly creating web applications in Ruby with minimal effort.
It is [well documented](http://www.sinatrarb.com/), so this introduction does
not go into much detail of using the sinatra code itself. Instead beyond showing
a couple of basic examples, it concentrates on other considerations such as
how to create test and console environments.

Hello World
-----------
The following 4 lines of code comprise a very simple sinatra app

    require 'sinatra'

    get '/' do
      'Hello world!'
    end

This is taken from the Sinatra documentation and is the code in simple/hello_world.rb

To run this code, navigate to the root of simple at the console and enter:

    ruby hello_world.rb

You should see output something like this:

    == Sinatra/1.4.5 has taken the stage on 4567 for development with backup from Thin
    Thin web server (v1.6.2 codename Doc Brown)
    Maximum connections set to 1024
    Listening on localhost:4567, CTRL+C to stop

If you point you browser at http://localhost:4567 you should see the 'Hello World'
message.

To close the server us ctrl-C.

Enabling changes
----------------
Note that if you make a change to a Sinatra app, that you will need to restart
the app for the change to take effect.

MyApp
-----
MyApp is the main Sinatra app used in the rest of this presentation. The code
associated with MyApp can be found in main/.

### lib

The app code is in a lib folder. This makes it easier to package
the code in a gem if that's needed later down the line.

### Sinatra::Application and Sinatra::Base

Using Sinatra::Application allows the application to be hosted by rack. That
makes it a lot easier to host the app in the same production environment as
rails applications.

Sinatra::Base is an alternative to Sinatra::Application, with less features
enabled by default. See the [Sinatra documentation for a more detailed description
of the differences](http://www.sinatrarb.com/intro.html#Sinatra::Base%20-%20Middleware,%20Libraries,%20and%20Modular%20Apps).

So the first change from the hello world example is that the core code is
hosted within a MyApp class defined with:

    class MyApp < Sinatra::Application

### Rackup

To run the app via rack, a config.ru file needs to be created at the app
root. Such a file with this content is enough to get the app up:

    require './lib/my_app.rb'
    run MyApp

To run the app, use the command *rackup*. Note that the app will now be
hosted on port 9292, that is your browser now needs to pointed at
http://localhost:9292/



