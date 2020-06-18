require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "secret"
  end

  get '/' do
    erb :index
  end

  get '/login' do
  end

  post '/login' do
  end

  get '/signup' do
  end

  post '/signup' do
  end

  get '/logout' do
    session.clear
    redirect '/login'
  end

end
