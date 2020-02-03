class UsersController < ApplicationController
  skip_before_action :authorized, only: [:new, :create, :edit]
  def new
  	 @user = User.new
  end

  def create
   @user = User.new(user_params)
   if @user.save
   else
    render json: {errors: @user.errors, message: "Inputs are not correct" } 
  end
   #session[:user_id] = @user.id
   #redirect_to login_path#'/show'
   #render json: { profile_id: @user.id, 
    #message: "You have successfully signed up" }

  end
   def got_profile
=begin
    @user=User.find_by(id: params[:id])
    render json:
    {
      id: @user.id,
      username: @user.username,
      full_name: @user.full_name,
      email_id: @user.email_id,
      phone_number: @user.phone_number,
      user_category: @user.user_category
    } 
=end
   end
  #def show
   # render plain: 'show'
   # if logged_in?
     #@user = User.find_by(id: params[:id])

    #end
  #end
  def update
   
    if current_user.update(user_params)
      redirect_to users1_got_profile_path
    end
  end
  def edit
    #render plain: "efb"
    @user = Rails.cache.read(current_user.id)
    if @user == nil
      @user = User.find_by(id: current_user.id)
    end
  end
  def reports
  end
  
 
  private
    def user_params
      params.require(:user).permit(:full_name, :username, :email_id, :phone_number, :password, :user_category)
    end
end
