class RatesController < ApplicationController
  before_action :authenticate_user!

  def create
    @rate = Rate.new
    @photo = Photo.find(params[:photo_id])
    rate = current_user.rates.new(rate_params)
    rate.photo_id = @photo.id
    if rate.save
      flash.now[:notice] = '評価を投稿しました'
    else
      flash.now[:alert] = '評価を投稿できませんでした'
    end
  end

  def destroy
    Rate.find(params[:id]).destroy
    @photo = Photo.find(params[:photo_id])
    @rate = Rate.new
    flash.now[:notice] = '評価を削除しました'
  end

    private

    def rate_params
      params.require(:rate).permit(:rate, :comment)
    end

end
