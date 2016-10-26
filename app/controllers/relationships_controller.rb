class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def index
    @title = params[:type]
    @user = User.find_by id: params[:user_id]
    if @user.nil?
      redirect_to root_path
    else
      @users = @user.send(@title).paginate page: params[:page],
        per_page: 5
    end
  end

  def create
    user = User.find_by id: params[:followed_id]
    current_user.follow user
    redirect_to user
  end

  def destroy
    user = Relationship.find(params[:id]).followed
    current_user.unfollow user
    redirect_to user
  end
end
