class CommunityController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.name.blank?
      redirect_to edit_community_path(current_user.id)
    else
      redirect_to "/forum"
    end
  end

  def edit
    @user = current_user
  end

  def update
    if params[:user][:name].length <= 2
      redirect_to edit_community_path(current_user.id), notice: 'Der Name ist zu kurz'
    elsif User.find_by_name(params[:user][:name])
      redirect_to edit_community_path(current_user.id), notice: 'Der Name ist leider schon vergeben...'
    else
      @user = current_user
      @user.update_attributes(name: params[:user][:name])
      redirect_to "/forum"
    end
  end
end
