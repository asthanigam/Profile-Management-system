class UsersController < ApplicationController
  skip_before_action :authorized, only: [:new, :create, :edit]
  
  def new
    
  	 @user = User.new
  end

  def create
   @user = User.new(user_params)
   #@user_parent = @user.parent
   #@user_parent_parent = @user_parent.parent
   #if @user_parent_parent.parent_id == nil && @user_parent.children.count < 4 
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
    respond_to do | format |
      format.json {render :json=> current_user}
      format.html 
    end
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
      Rails.cache.write(current_user.id,current_user)
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
      params.require(:user).permit(:id, :full_name, :username, :email_id, :phone_number, :password, :parent_id, :user_category)
    end
end
