require 'sinatra'

class MyApp < Sinatra::Application

  get '/' do
    'Hello world!'
  end

  get '/log/:message' do
    logger.info "Log action message: #{params[:message]}"
    "Message '#{params[:message]}' added to log"
  end

end
