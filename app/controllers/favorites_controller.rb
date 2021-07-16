class FavoritesController < ApplicationController
  before_action :current_user_blank?

  def create
    @photo = Photo.find(params[:photo_id])
    favorite = current_user.favorites.new(photo_id: @photo.id)
    favorite.save
  end

  def destroy
    @photo = Photo.find(params[:photo_id])
    favorite = current_user.favorites.find_by(photo_id: @photo.id)
    favorite.destroy
  end

# 　非ログインユーザーはログイン画面へ
  def current_user_blank?
    if current_user.blank?
      flash[:alert] = 'いいねにはログインが必要です'
      redirect_to request.referer
    end
  end

end
