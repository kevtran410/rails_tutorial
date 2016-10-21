class PasswordResetsController < ApplicationController
  before_action :find_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:infor] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found!"
      render :new
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.error.add :password, "Can't be empty."
      render :edit
    elsif @user.update_attributes user_params
      log_in @user
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render :edit
    end
  end

  private
  def find_user
    @user = User.find_by email: params[:email]
    unless @user && @user.activated? && @user.authenticated?(:reset, params[:id])
      flash[:danger] = "Can't find that user"
      redirect_to root_url
    end
  end

  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = "Password reset has expired."
      redirect_to new_password_resets_url
    end
  end

  def user_params
    params.required(:user).permit :password, :password_confirmation
  end
end