require 'rack-flash'

class ApplicationController < Sinatra::Base
  
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_secret"
    use Rack::Flash, :sweep => true
  end

  get '/' do
    if !logged_in?
      erb :index
    else
      redirect '/projects'
    end
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end

    def flash_types
      [:success, :notice, :warning, :error]
    end
  end

end
