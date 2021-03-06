class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :create]
  before_action :verify_admin, only: :destroy
  before_action :find_user, except: [:index, :new, :create]
  before_action :valid_user, only: [:edit, :update]

  def index
    @users = User.already_activated.paginate page: params[:page], per_page: 10
  end

  def show
    @microposts = @user.microposts.order_by_descending.
      paginate page: params[:page], per_page: 5
    redirect_to root_url unless @user.activated?
    if current_user.following? @user
      @relationship = current_user.active_relationships.find_by followed_id: @user.id
    else
      @relationship = current_user.active_relationships.build
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to @user
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    User.find_by(id: params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  private
  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end

  def find_user
    @user = User.find_by id: params[:id]
    if @user.nil?
      flash.alert = "Can't find that user"
      redirect_to root_path
    end
  end

  def valid_user
    redirect_to root_url unless @user.current_user? current_user
  end

  def verify_admin
    redirect_to root_url unless current_user.admin?
  end
end
