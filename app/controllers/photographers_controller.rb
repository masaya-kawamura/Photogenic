class PhotographersController < ApplicationController

  def new
    @photographer = Photographer.new
    @user = current_user
  end

  def create
    photographer = Photographer.new(photographer_params)
    photographer.user_id = current_user.id
    if photographer.save
      genres = params[:genre].split(" ")
      # photographerインスタンスに対してsave_photographerメソッド呼び出し
      photographer.save_photographer_genres(genres)
      user = photographer.user
      user.update(user_status: "フォトグラファー", photographer_id: photographer.id)
      flash[:notice] = "フォトグラファー登録が完了しました"
      redirect_to mypage_path
    else
      @photographer = photographer
      render :new
    end
  end

  def show
    @photographer = Photographer.find(params[:id])
    @user = @photographer.user
  end

  def edit
    @photographer = Photographer.find(params[:id])
  end

  def update
    photographer = Photographer.find(params[:id])
    if photographer.update(photographer_params)
      genres = params[:photographer][:genre].split(" ")
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
    @photographers = Photographer.all
  end

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

    private

    def photographer_params
      params.require(:photographer).permit(
        :name,
        :area,
        :introduction,
        :instagram_url,
        :facebook_url,
        :public_status
      )
    end

end
