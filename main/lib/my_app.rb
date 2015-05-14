require 'sinatra'
require 'sinatra/form_helpers'

class MyApp < Sinatra::Application

  helpers Sinatra::FormHelpers

  get '/' do
    'Hello world!'
  end

  get '/form' do
    erb :form
  end

  post '/form' do
    params.inspect
  end

  get '/log/:message' do
    logger.info "Log action message: #{params[:message]}"
    "Message '#{params[:message]}' added to log"
  end

end
