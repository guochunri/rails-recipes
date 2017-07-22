class Admin::UsersController < AdminController

  before_action :require_admin!
  
  def index
    @users = User.includes(:groups).all  #避免 N+1 Query 效能问题
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to admin_users_path
    else
      render "edit"
    end
  end

  protected

  def user_params
    params.require(:user).permit(:email)
    params.require(:user).permit(:email, :group_ids => [])
  end

end
