class RatesController < ApplicationController

  def create
    photo = Photo.find(params[:photo_id])
    rate = current_user.rates.new(rate_params)
    rate.photo_id = photo.id
    if rate.save
      flash[:notice] = "評価が完了しました"
      redirect_to photo_path(photo)
    else
      flash[:alert] = "申し訳ございませんが、評価投稿する事ができませんでした。"
      @photo = photo
      @user = @photo.user
      @rate = rate
      @comment = Comment.new
      render 'photos/show'
    end
  end

  def destroy
    Rate.find(params[:id]).destroy
    redirect_to photo_path(params[:photo_id])
  end

    private

    def rate_params
      params.require(:rate).permit(:rate, :comment)
    end

end
