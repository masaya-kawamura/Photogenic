class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def mypage
    @user = current_user
    @photos = Photo.where("user_id IN (?) OR user_id = ?", @user.following_ids, @user.id).order(id: "DESC")
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    user = User.find(params[:id])
    if user.update(user_params)
      redirect_to mypage_path
    else
      @user = user
      render :edit
    end
  end

  def destroy
  end

  def follower
    @title = "Follower"
    @user = User.find(params[:id])
    @users = @user.follower
    render 'show_follow'
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following
    render 'show_follow'
  end

  def ensure_correct_user
    user = User.find(params[:id])
    if user.id != current_user.id
      flash[:alert] = '権限がありません'
      redirect_to request_referer
    end
  end

    private

    def user_params
      params.require(:user).permit(
        :name,
        :email,
        :profile_image,
        :area
      )
    end

end
