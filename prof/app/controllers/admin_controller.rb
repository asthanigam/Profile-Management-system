class AdminController < ApplicationController
  skip_before_action :authorized
	def create
		  @admin = Admin.find_by(username: params[:username])
   if @admin && @admin.authenticate(params[:password])
      session[:user_id] = @admin.id
      #render plain: 'Here'
      render 'show'
   else
   	   render plain: 'Wrong inputs'
      #redirect_to 'users/show'
  	end
	end

	def login
    #render plain: "def"
	end
  def showprofile
  @user = User.find(params[:user_id])
    #if @user == nil
      #@user = User.find_by(id: users.id)
    end
#=end
  #end
  def edituser
    #@user = User.find_by(id: user.id)
    @user = User.find(params[:user_id])
  end
   def update
    @user = User.find_by(id: user_params[:id])
    if @user.update(user_params)
      redirect_to admin_showprofile_path(:user_id => @user.id)
    end
  end
  #def edit
    #render plain: "hi"
    #redirect_to edit_user_path
  #end
  def searching
    if params[:q].nil?
    else
      @users = User.search params[:q]
    end
  end
  
  def reports
    #File.read("output.txt")
    render plain: 'See output.txt file for number of users'
    #UserWorker.perform_async
    
  end
  private
    def user_params
      params.require(:user).permit(:id, :full_name, :username, :email_id, :phone_number, :password, :user_category)
    end



end
