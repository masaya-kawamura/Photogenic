class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]
  before_action :ensure_nomal_user, only: :destroy

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

  def withdrawal_confirmation
  end

  def destroy
    user = current_user
    user.destroy
    reset_session
    flash[:notice] = '退会処理が完了しました。'
    redirect_to root_path
  end

  def follower
    @title = "Follower"
    @user = User.find(params[:id])
    @users = @user.follower.page(params[:page]).per(8)
    render 'show_follow'
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.page(params[:page]).per(8)
    render 'show_follow'
  end

  def ensure_correct_user
    user = User.find(params[:id])
    if user.id != current_user.id
      flash[:alert] = '権限がありません'
      redirect_to mypage_path
    end
  end

  def ensure_nomal_user
    if current_user.email == 'guest@example.com'
      redirect_to mypage_path, alert: 'このアカウントは削除できません。'
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
