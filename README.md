An Introduction to Sinatra
==========================

Sinatra is a DSL for quickly creating web applications in Ruby with minimal effort.
It is [well documented](http://www.sinatrarb.com/), so this introduction does
not go into much detail of using the sinatra code itself. Instead beyond showing
a couple of basic examples, it concentrates on other considerations such as
how to create test and environments.

Hello World
-----------
The following 4 lines of code comprise a very simple sinatra app

    require 'sinatra'

    get '/' do
      'Hello world!'
    end

This is take from the Sinatra documentation and is the code in simple/hello_world.rb

To run this code, navigate to the root of simple at the console and enter:

    ruby hello_world.rb

You should see output something like this:

    == Sinatra/1.4.5 has taken the stage on 4567 for development with backup from Thin
    Thin web server (v1.6.2 codename Doc Brown)
    Maximum connections set to 1024
    Listening on localhost:4567, CTRL+C to stop

If you point you browser at http://localhost:4567 you should see the 'Hello World'
message.

Do close the server us ctrl-C.

