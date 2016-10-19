class AccountActivationsController < ApplicationController
  before_action :find_user_by_email, only: :update

  def update
    if !@user.activated? && @user.authenticated?(:activation, params[:id])
      @user.activate
      log_in @user
      flash[:success] = "Account activated"
      redirect_to @user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end

  private
  def find_user_by_email
    @user = User.find_by email: params[:email]
    if @user.nil?
      flash.alert = "Can't find that email activation"
      redirect_to root_url
    end
  end
end
