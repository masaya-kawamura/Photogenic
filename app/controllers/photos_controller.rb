class PhotosController < ApplicationController

  def new
    @photo = Photo.new
  end

  def create
    photo = current_user.photos.new(photo_params)
    if photo.save
      # ======= ジャンル保存メソッドへ =========
      genres = params[:photo][:genre].split(/[[:blank:]]+/)
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
    @rate = Rate.new
    @genres = @photo.genres
    # ========= recomendデータ取得用 ============
    photos = []
    @genres.each do |genre|
      genre.photos.each do |photo|
        photos << photo
      end
    end
    unless photos.empty?
      @photos = photos.uniq.sort.reverse - [@photo]
    else
      @photos = Photo.limit(16).order('id DESC') - [@photo]
    end
    # ===========================================
  end

  def index
    @photos = Photo.all.order('id DESC')
  end

  def edit
    @photo = Photo.find(params[:id])
    genre_names_array = @photo.genres.pluck(:name)
    @genre_names = genre_names_array.join(' ')
  end

  def update
    photo = Photo.find(params[:id])
    if photo.update(photo_params)
      # ======= ジャンル保存メソッドへ =========
      genres = params[:photo][:genre].split(/[[:blank:]]+/)
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
