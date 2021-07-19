class PhotographersController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :public_status_confirmation, only: [:show]
  before_action :ensure_correct_photographer, only: [:edit, :update, :destroy, :public_status_switching]

  def new
    @photographer = Photographer.new
    @user = current_user
  end

  def create
    photographer = Photographer.new(photographer_params)
    photographer.user_id = current_user.id
    if photographer.save
      genres = params[:photographer][:genre].split(/[[:blank:]]+/)
      # photographerインスタンスに対してsave_photographerメソッド呼び出し
      photographer.save_photographer_genres(genres)
      user = photographer.user
      user.update(user_status: "フォトグラファー", photographer_id: photographer.id)
      flash[:notice] = "フォトグラファー登録が完了しました"
      redirect_to mypage_path
    else
      @photographer = photographer
      @user = current_user
      render :new
    end
  end

  def show
    @photographer = Photographer.find(params[:id])
    @user = @photographer.user
    @photos = @user.photos.order(id: 'DESC')
  end

  def edit
    @photographer = Photographer.find(params[:id])
    genre_names_array = @photographer.genres.pluck(:name)
    @genre_names = genre_names_array.join(' ')
  end

  def update
    photographer = Photographer.find(params[:id])
    if photographer.update(photographer_params)
      genres = params[:photographer][:genre].split(/[[:blank:]]+/)
      # photographerインスタンスに対してsave_photographerメソッド呼び出し
      photographer.save_photographer_genres(genres)
      flash[:notice] = "プロフィールを編集しました"
      redirect_to photographer_path(photographer)
    else
      @photographer = photographer
      render :edit
    end
  end

  def destroy
  end

  def index
    @photographers = Photographer.where(public_status: true).page(params[:page]).per(8).order(id: 'DESC')
  end

  # プロフィールの公開設定を切り替える
  def public_status_switching
    photographer = Photographer.find(params[:id])
    if photographer.toggle!(:public_status)
      flash[:notice] = "プロフィールの公開設定を更新しました"
      redirect_to photographer_path(photographer)
    else
      @photographer = photographer
      @user = @photographer.user
      flash[:alert] = "プロフィール公開設定の更新に失敗しました"
      render :show
    end
  end

  # プロフィールの公開設定falseだったらリダイレクト
  #　でも本人だけはアクセスできる。
  def public_status_confirmation
    @photographer = Photographer.find(params[:id])
    if current_user.present? && current_user.id == @photographer.user.id
      true
    else
      if @photographer.public_status == false
        flash[:notice] = "#{@photographer.name}さんはプロフィールを公開していません"
        redirect_to request.referer
      else
        true
      end
    end
  end

  # 本人のみ編集が可能
  def ensure_correct_photographer
    photographer = Photographer.find(params[:id])
    if photographer.user.id != current_user.id
      flash[:alert] = "権限がありません"
      redirect_to mypage_path
    end
  end

    private

    def photographer_params
      params.require(:photographer).permit(
        :name,
        :area,
        :introduction,
        :photographer_profile_image,
        :cover_image,
        :instagram_url,
        :facebook_url,
        :public_status
      )
    end

end