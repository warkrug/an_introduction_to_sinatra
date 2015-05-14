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

To close the server use ctrl-C.

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

### Views

Sinatra supports views (html templates). The default location to host the templates
is in a /views folder (relative to the app). Sinatra supports a number of
template formats including erb which is used in MyApp.

The form action uses a view:

    get '/form' do
      erb :form
    end

When the browser is pointed at http://localhost:9292/form, the template at
views/form.erb will be rendered (notice not form.html.erb).

### Sinatra::FormHelpers

[Sinatra::FormHelpers](https://rubygems.org/gems/sinatra-formhelpers/versions/0.4.0)
adds HTML form methods (for example: form, label, input, select, and submit) that
makes it relatively easy to create an erb form.

For example:

    <%= form('form', :post) %>

    <p>
      <%= label(:message, :text, 'Message text') %><br>
      <%= input(:message, :text) %>
    </p>

    <p><%= submit('Send message') %></p>

    </form>

Notice that the form has to be closed manually with a </form> tag.

The form is submitted via a post. Therefore a route needs to be
present to handle that post action.

    post '/form' do
      params.inspect
    end

As with rails, the attributes passed to the app, are packaged up in a params
object. In the above example, the response is simply a display of the contents
of this object.

### Passing variables via the url

Let's pass a variable in and add it to the application log. The log action does
just that:

    get '/log/:message' do
      logger.info "Log action message: #{params[:message]}"
      "Message '#{params[:message]}' added to log"
    end

Notice that :message in the route url causes the text entered at this point
in the url, to be passed to params[:message]

If we then point the browser at http://localhost:9292/log/foo the following
message should appear in the log:

    INFO -- : Log action message: foo

### Logging to a file

Logs are usually sent to the standard output of the rack server via stdout and
stderr (the standard linux output streams).

However, for myapp, I want the log output to go to a file log/my_app.log. To
do that I add the following code to config.ru:

    log = File.new("log/my_app.log", "a+")
    $stdout.reopen(log)
    $stderr.reopen(log)

    $stderr.sync = true
    $stdout.sync = true

(In the code at main/config.ru these lines are commented out.)

### Rake commands

Some useful utilities can be added to a Sinatra app by adding a Rakefile in
which rake commands can be defined.

#### A console

Whilst developing and debugging an app, it is useful to be able to access
a command console with the apps objects enabled. The following code in Rakefile
enables this:

    require 'rubygems'
    require 'rake'

    task :console do
      require 'irb'
      require 'irb/completion'
      require './lib/my_app'
      ARGV.clear
      IRB.start
    end

To access the console enter *rake console*

For example:

    rob@robvm:~/main$ rake console
    1.9.3-p547 :001 > MyApp.ancestors
     => [MyApp, Sinatra::Application, Sinatra::FormHelpers, Sinatra::Base, Sinatra::Templates, Sinatra::Helpers, Rack::Utils, Object, Kernel, BasicObject]
    1.9.3-p547 :002 > exit

#### rdoc documentation

The following additions to Rakefile add the facility to build rdoc documentation
from the app code:

    require 'rake/clean'
    require 'rdoc/task'

    Rake::RDocTask.new do |rdoc|
      files =['lib/**/*.rb']
      rdoc.rdoc_files.add(files)
      rdoc.title = "An Introduction to Sinatra Docs"
      rdoc.rdoc_dir = 'doc/rdoc' # rdoc output folder
      rdoc.options << '--line-numbers'
    end

To run the task use the command *rake rdoc*

This will create documentation at doc/rdoc. See my presentation
[Documenting your projects](https://github.com/warkrug/documenting_your_projects)
for more information on creating rdoc friendly code.

#### running tests

The following code adds the facility of running tests via the rake command.

    require 'rake/testtask'

    Rake::TestTask.new do |t|
      t.libs << 'lib'
      t.libs << "test"
      t.pattern = 'test/**/*_test.rb'
      t.verbose = false
    end

The command *rake test* will run the tests.

See the Tests section below.

#### Adding a default task

The following command make the test task the default task. That is, the task
run if you just enter *rake* and the command line.

    task :default => :test

### Tests

A test helper makes it simple to use a shared environment across all your
apps. test/test_helper.rb defines this environment:

    ENV['RACK_ENV'] = 'test'

    require 'test/unit'
    require 'rack/test'

    require 'my_app'

    class Test::Unit::TestCase

      def app
        MyApp
      end

    end

With that in place, the test at test/my_app/my_app_test.rb just needs
to require 'test_helper' to use the shared environment. The rest of the
test then runs when the *rake test* rake task is run.

    require 'test_helper'

    class MyAppTest < Test::Unit::TestCase
      include Rack::Test::Methods

      def test_root
        get '/'
        assert last_response.ok?
        assert_match /Hello world/, last_response.body
      end

    end

This is a standard ruby unit test. Including Rack::Test::Methods adds
methods to facilitate tests of the Sinatra functionality. In this case the
get and last_response method. Notice that the app method needs to return
the main sinatra app and that this was done for all tests by defining it
in test_helper.