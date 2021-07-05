class UsersController < ApplicationController

  def mypage
    @user = current_user
  end

  def edit
    @user = current_user
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

    private

    def user_params
      params.require(:user).permit(
        :name,
        :email,
        :profile_image,
        :cover_image,
        :area
      )
    end

end
