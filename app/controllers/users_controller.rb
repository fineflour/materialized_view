class UsersController < ApplicationController
  def index
    @users = User.paginate(page: params[:page])
  end

  def show
       @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :role)
  end
end
