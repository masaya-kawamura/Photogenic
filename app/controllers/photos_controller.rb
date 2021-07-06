class PhotosController < ApplicationController

  def new
    @photo = Photo.new
  end

  def create
    photo = current_user.photos.new(photo_params)
    if photo.save
      flash[:notice] = "写真を投稿しました"
      redirect_to photo_path(photo.id)
    else
      flash[:alert] = "写真を投稿できませんでした"
      @photo = photo
      render :new
    end
  end

  def show
    @photo = Photo.find(params[:id])
    @user = @photo.user
  end

  def index
  end

  def edit
  end

  def update
  end

  def destroy
  end

    private

    def photo_params
      params.require(:photo).permit(:photo_image, :story, :detail)
    end

end
