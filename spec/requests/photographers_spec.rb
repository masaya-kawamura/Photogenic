require 'rails_helper'

RSpec.describe PhotographersController, type: :controller do
  before do
    @user = FactoryBot.create(:user)
  end

  describe "#index" do
    it '正常なレスポンスを返すこと' do
      get :index
      expect(response).to be_successful
    end
    it '200レスポンスを返すこと' do
      get :index
      expect(response).to have_http_status '200'
    end
  end

  describe '#show' do
    before do
      @photographer = FactoryBot.create(
        :photographer,
        user_id: @user.id,
        public_status: true
      )
    end

    it '正常なレスポンスを返すこと' do
      get :show, params: { id: @photographer.id }
      expect(response).to be_successful
    end
    it '200レスポンスを返すこと' do
      get :show, params: { id: @photographer.id }
      expect(response).to have_http_status '200'
    end
  end

  describe '#new' do
    context 'ログインユーザーの場合' do
      before do
        sign_in @user
      end

      it '正常なレスポンスを返すこと' do
        get :new
        expect(response).to be_successful
      end
      it '200レスポンスを返すこと' do
        get :new
        expect(response).to have_http_status '200'
      end
    end

    context 'ログインユーザーじゃなかった場合' do
      it 'ログイン画面へリダイレクトする' do
        get :new
        expect(response).to redirect_to '/login'
      end
      it '302レスポンスを返すこと' do
        get :new
        expect(response).to have_http_status '302'
      end
    end
  end

  describe '#create' do
    before do
      @params_photographer = FactoryBot.attributes_for(:photographer)
    end

    context 'ログインユーザーの場合' do
      it 'フォトグラファー登録ができること' do
        sign_in @user
        expect do
          post :create, params: { photographer: @params_photographer }
        end.to change(Photographer, :count).by(1)
      end
    end

    context 'ログインしていないユーザーの場合' do
      it '302レスポンスを返すこと' do
        post :create, params: { photographer: @params_photographer }
        expect(response).to have_http_status '302'
      end
      it 'login画面にリダイレクトすること' do
        post :create, params: { photographer: @params_photographer }
        expect(response).to redirect_to '/login'
      end
    end
  end

  describe '#edit' do
    before do
      @photographer = FactoryBot.create(:photographer, user_id: @user.id)
      @other_user = FactoryBot.create(:user)
      @other_photographer = FactoryBot.create(:photographer, user_id: @other_user.id)
    end

    context 'フォトグラファー本人だったら' do
      before do
        sign_in @user
      end

      it '正常なレスポンスを返すこと' do
        get :edit, params: { id: @photographer.id }
        expect(response).to be_successful
      end
      it '200レスポンスを返すこと' do
        get :edit, params: { id: @photographer.id }
        expect(response).to have_http_status '200'
      end
    end

    context '本人じゃなかったら' do
      before do
        sign_in @user
      end

      it '302レスポンスを返す' do
        get :edit, params: { id: @other_photographer.id }
        expect(response).to have_http_status '302'
      end
      it 'mypageにリダイレクトすること' do
        get :edit, params: { id: @other_photographer.id }
        expect(response).to redirect_to '/mypage'
      end
    end

    context 'ログインユーザーじゃなかったら' do
      it '302レスポンスを返す' do
        get :edit, params: { id: @photographer.id }
        expect(response).to have_http_status '302'
      end
      it 'login画面にリダイレクトする' do
        get :edit, params: { id: @photographer.id }
        expect(response).to redirect_to '/login'
      end
    end
  end

  describe '#update' do
    before do
      @photographer = FactoryBot.create(:photographer, user_id: @user.id)
      @other_user = FactoryBot.create(:user)
      @other_photographer = FactoryBot.create(:photographer, user_id: @other_user.id)
      @params_photographer = FactoryBot.attributes_for(:photographer, name: '山田 三郎')
    end

    context 'フォトグラファー本人だったら' do
      it '登録情報を更新できること' do
        sign_in @user
        patch :update, params: {
          id: @photographer.id, photographer: @params_photographer,
        }
        expect(@photographer.reload.name).to eq '山田 三郎'
      end
    end

    context 'フォトグラファー本人じゃなかったら' do
      it '登録情報の更新が行えないこと' do
        sign_in @user
        patch :update, params: {
          id: @other_photographer.id, photographer: @params_photographer,
        }
        expect(@other_photographer.reload.name).to eq '山田 太郎'
      end
      it 'mypagへリダイレクトすること' do
        sign_in @user
        patch :update, params: {
          id: @other_photographer.id, photographer: @params_photographer,
        }
        expect(response).to redirect_to '/mypage'
      end
    end

    context 'ログインユーザーじゃなかったら' do
      it '情報の更新を行いないこと' do
        patch :update, params: {
          id: @photographer.id, photographer: @params_photographer,
        }
        expect(@photographer.reload.name).to eq '山田 太郎'
      end
      it 'login画面にリダイレクトすること' do
        patch :update, params: {
          id: @photographer.id, photographer: @params_photographer,
        }
        expect(response).to redirect_to '/login'
      end
    end
  end

  describe '#public_status_switcing' do
    before do
      @photographer = FactoryBot.create(
        :photographer,
        user_id: @user.id,
        public_status: false
      )
      @other_user = FactoryBot.create(:user)
      @other_photographer = FactoryBot.create(
        :photographer,
        user_id: @other_user.id
      )
    end

    context 'フォトグラファー本人の場合' do
      it '公開設定の切り替えができること' do
        sign_in @user
        @photographer = FactoryBot.create(
          :photographer,
          user_id: @user.id,
          public_status: false
        )
        post :public_status_switching, params: { id: @photographer.id }
        expect(@photographer.reload.public_status).to eq true
      end
    end

    context '本人じゃなかった場合' do
      before do
        sign_in @user
        @other_photographer = FactoryBot.create(
          :photographer,
          user_id: @other_user.id,
          public_status: false
        )
      end

      it '公開設定の更新ができないこと' do
        post :public_status_switching, params: { id: @other_photographer.id }
        expect(@other_photographer.reload.public_status).to eq false
      end
      it 'マイページにリダイレクトすること' do
        post :public_status_switching, params: { id: @other_photographer.id }
        expect(response).to redirect_to '/mypage'
      end
    end

    context 'ログインユーザーじゃなかった場合' do
      it '公開設定の更新ができないこと' do
        post :public_status_switching, params: { id: @photographer.id }
        expect(@photographer.reload.public_status).to eq false
      end
      it 'loginページへリダイレクトすること' do
        post :public_status_switching, params: { id: @photographer.id }
        expect(response).to redirect_to '/login'
      end
    end
  end
end
