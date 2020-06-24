class ProjectsController < ApplicationController

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
        if logged_in?
            @user = User.find(session[:user_id])
            if params[:title].empty? || params[:description].empty? || params[:cost].empty?
                redirect '/projects/new'
            else
                @project = Project.create(:title => params[:title], :description => params[:description], :cost => params[:cost], :user_id => session[:user_id])

                flash[:success] = "Nice! You created a new project!"
                
                redirect '/projects'
            end
        else
            redirect '/login'
        end
    end
    
    get '/projects/:id' do
        if !logged_in?
            redirect '/login' 
        else
            @project = Project.find(params[:id])
            if @project && @project.user == current_user
                erb :'/projects/show'
            else
                redirect '/login'
            end
        end
    end
    
    get '/projects/:id/edit' do
        if !logged_in?
            redirect '/login' 
        else
            @user = User.find(session[:user_id])
            @project = Project.find(params[:id])
            if @project && @project.user == current_user
                erb :'/projects/edit'
            else
                redirect '/login'
            end
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
          flash[:success] = "Nice! You edited your project!"
          
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

end