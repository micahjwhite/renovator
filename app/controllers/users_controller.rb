class UsersController < ApplicationController

    get '/users' do
        if logged_in?
            @user = User.find(session[:user_id])
            erb :'users/index'
        else
            redirect '/login'
        end
    end

    get '/users/:id' do
        if logged_in?
            @user = User.find(params[:id])
            erb :'users/show'
        else
            redirect '/login'
        end
    end

    get '/login' do
        if logged_in?
          redirect '/projects'
        else
          erb :'login'
        end
    end
    
    post '/login' do
        @user = User.find_by(:username => params[:username])
        if @user && @user.authenticate(params[:password])
          session[:user_id] = @user.id
          redirect '/projects'
        else
          redirect '/login'
        end
    end

    get '/signup' do
        if logged_in?
          redirect '/projects'
        else
          erb :'signup'
        end
      end
    
      post '/signup' do
        if params[:username].empty? || params[:password].empty?
          redirect '/signup'
        else
          @user = User.create(username: params[:username], password: params[:password])
          session[:user_id] = @user.id
          redirect '/projects'
        end
      end
    
      get '/logout' do
        if logged_in?
            session.clear
            redirect '/login'
        else
            redirect '/'
        end
      end
end