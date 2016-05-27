class Admin::UsersController < ApplicationController

  before_filter :restrict_to_admin

  def index
   @users = User.order(:email).page params[:page]
  end

  def show
   @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id # auto login
      redirect_to movies_path, notice: "Popcorn's ready, #{@user.firstname}!"
    else
      render :new
    end
  end

  def destroy
   @user = User.find(params[:id])
   @user.destroy
   redirect_to admin_users_path
  end



  protected

  def user_params
    params.require(:user).permit(:email, :firstname, :lastname, :password, :password_confirmation)
  end

end
