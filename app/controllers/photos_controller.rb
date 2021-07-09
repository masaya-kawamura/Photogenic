class PhotosController < ApplicationController

  def new
    @photo = Photo.new
  end

  def create
    photo = current_user.photos.new(photo_params)
    if photo.save
      # ======= ジャンル保存メソッドへ =========
      genres = params[:photo][:genre].split(' ')
      photo.save_photos(genres)
      # ========================================
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
    @comments = @photo.comments
    @comment = Comment.new
  end

  def index
    @photos = Photo.all
  end

  def edit
    @photo = Photo.find(params[:id])
  end

  def update
    photo = Photo.find(params[:id])
    if photo.update(photo_params)
      # ======= ジャンル保存メソッドへ =========
      genres = params[:photo][:genre].split(' ')
      photo.save_photos(genres)
      # ========================================
      flash[:notice] = "投稿を編集しました"
      redirect_to photo_path(photo)
    else
      @photo = photo
      render :edit
    end
  end

  def destroy
    photo = Photo.find(params[:id])
    photo.destroy
    redirect_to photographer_path(current_user.photographer)
  end

    private

    def photo_params
      params.require(:photo).permit(:photo_image, :story, :detail)
    end

end
