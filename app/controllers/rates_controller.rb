class RatesController < ApplicationController

  def create
    @photo = Photo.find(params[:photo_id])
    rate = current_user.rates.new(rate_params)
    rate.photo_id = @photo.id
    rate.save
    @rate = Rate.new
  end

  def destroy
    Rate.find(params[:id]).destroy
    @photo = Photo.find(params[:photo_id])
    @rate = Rate.new
  end

    private

    def rate_params
      params.require(:rate).permit(:rate, :comment)
    end

end
