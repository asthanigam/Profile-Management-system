class SessionsController < ApplicationController
skip_before_action :authorized, only: [:new, :create, :welcome]
def new
end
def login

end
def create
	
   @user = User.find_by(username: params[:username])
   if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      Rails.cache.write(@user.id,@user)
      #render plain: 'Here'
      redirect_to '/users1/got_profile'#'/welcome'
   else
   	   render plain: 'Wrong inputs'
      #redirect_to 'users/show'
  	end
   
end
def page_requires_login
end
def destroy
	session[:user_id]=nil
	redirect_to '/welcome'
end
end