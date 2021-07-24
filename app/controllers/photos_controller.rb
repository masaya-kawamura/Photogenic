class PhotosController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :is_photographer?, only: [:new, :create, :edit, :update, :destroy]
  before_action :ensure_correct_photographer_photo, only: [:edit, :update, :destroy]

  def new
    @photo = Photo.new
  end

  def create
    change_filename_encoding
    photo = current_user.photos.new(photo_params)
    
    if photo.save
      # ======= ジャンル保存メソッドへ =========
      if params[:photo][:genre].present?
        genres = params[:photo][:genre].split(/[[:blank:]]+/)
        photo.save_photos(genres)
      end
      # ========================================
      flash[:notice] = "写真を投稿しました"
      redirect_to photo_path(photo.id)
    else
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
    if photos.empty?
      @photos = Photo.limit(16).order('id DESC') - [@photo]
    else
      @photos = photos.uniq.sort.reverse - [@photo]
    end
    # ===========================================
  end

  def index
    @photos = Photo.all.page(params[:page]).per(8).order('id DESC')
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
      if params[:photo][:genre].present?
        genres = params[:photo][:genre].split(/[[:blank:]]+/)
        photo.save_photos(genres)
      end
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
    flash[:notice] = '写真を削除しました'
    redirect_to mypage_path
  end

  # 編集や削除は投稿者本人しか実行できない
  def ensure_correct_photographer_photo
    @photo = Photo.find(params[:id])
    if @photo.user.id != current_user.id
      flash[:alert] = "権限がありません"
      redirect_to mypage_path
    end
  end

  def is_photographer?
    if current_user.user_status != 'フォトグラファー'
      flash[:alert] = '写真の投稿にはフォトグラファー登録が必要です'
      redirect_to mypage_path
    end
  end

  private

  def photo_params
    params.require(:photo).permit(:photo_image, :caption)
  end

  def change_filename_encoding
    photo_params[:photo_image].headers.force_encoding('utf-8')
  end
end
