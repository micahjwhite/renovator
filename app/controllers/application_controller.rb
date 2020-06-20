require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_secret"
  end

  get '/' do
    erb :index
  end

  get '/login' do
    if logged_in?
      redirect '/projects'
    else
      erb :'login'
    end
  end

  post '/login' do
    user = User.find_by(:username => params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
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
    if params[:username] == "" || params[:password] == ""
      redirect '/signup'
    else
      user = User.create(username: params[:username], password: params[:password])
      session[:user_id] = user.id
      redirect '/projects'
    end
  end

  get '/logout' do
    session.clear
    redirect '/login'
  end

  get '/projects' do
    if !logged_in?
      redirect '/login'
    else
      @user = User.find(session[:user_id])
      erb :'projects/index'
    end
  end

  get '/projects/new' do
    if !logged_in?
      redirect '/login' 
    else
      @user = User.find(session[:user_id])
      erb :'/projects/new'
    end
  end

  post '/projects' do
    if params[:title].empty? || params[:description].empty? || params[:cost].empty?
      redirect '/projects/new'
    else
      @project = Project.create(:title => params[:title], :description => params[:description], :cost => params[:cost], :user_id => session[:user_id])
      redirect '/projects'
    end
  end

  get '/projects/:id' do
    if !logged_in?
      redirect '/login' 
    else
      @project = Project.find(params[:id])
      erb :'/projects/show'
    end
  end

  get '/projects/:id/edit' do
    if !logged_in?
      redirect '/login' 
    else
      @project = Project.find(params[:id])
      erb :'/projects/edit'
    end
  end

  patch '/projects/:id' do
    @project = Project.find(params[:id])
    if params[:title].empty? || params[:description].empty? || params[:cost].empty?
      redirect "/projects/#{@project.id}/edit"
    else
      @project.title = params[:title]
      @project.description = params[:description]
      @project.cost = params[:cost]
      @project.save
      redirect "/projects"
    end
  end

  delete '/projects/:id' do
    @project = Project.find(params[:id])
    if current_user != @project.user
      redirect "/projects/#{params[:id]}"
    else
      @project.delete
      redirect "/projects"
    end
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

end
