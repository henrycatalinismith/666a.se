class Admin::UsersController < AdminController
  layout "internal"

  def index
    @users = User::Account.reverse_chronological.all
  end

  def show
    @user = User::Account.find(params[:id])
  end
end
