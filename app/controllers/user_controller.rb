class UserController < ApplicationController
  before_action :authenticate_user!

  def edit
    @user = current_user
  end

  def update
    if params[:user][:name].length <= 2
      redirect_to edit_user_path(current_user.id), notice: 'Der Name ist zu kurz'
    else
      @user = current_user
      @user.update_attributes(name: params[:user][:name])
      redirect_to edit_user_path(current_user.id), notice: 'Der Name wurde angelegt'
    end
  end

  def destroy
    @user = current_user
    @user.destroy
    redirect_to root_path, notice: 'Wir haben deinen Account gelöscht'
  end
end
