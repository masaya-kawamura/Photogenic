require 'rails_helper'

RSpec.describe PhotosController , type: :controller do

  describe '#index' do
    it '正常にレスポンスを返すこと' do
      get :index
      expect(response).to be_successful
    end
    it '200レスポンスを返すこと' do
      get :index
      expect(response).to have_http_status '200'
    end
  end

  describe '#show' do
    let(:user) { FactoryBot.create(:user) }
    let(:photo) { FactoryBot.create(:photo, user_id: user.id) }
    it '正常なレスポンスを返すこと' do
      get :show, params: { id: photo.id }
      expect(response).to be_successful
    end
    it '200レスポンスを返すこと' do
      get :show, params: { id: photo.id }
      expect(response).to have_http_status '200'
    end
  end

  describe '#new' do
    context 'ユーザがフォトグラファーだった場合' do
      let(:user) { FactoryBot.create(:user, user_status: 'フォトグラファー') }
      it '正常にレスポンスを返すこと' do
        sign_in user
        get :new
        expect(response).to be_successful
      end
      it '200レスポンスを返すこと' do
        sign_in user
        get :new
        expect(response).to have_http_status '200'
      end
    end

    context 'ユーザーがフォトグラファーじゃなかったら' do
      let(:user) { FactoryBot.create(:user) }
      it 'mypageにリダイレクトすること' do
        sign_in user
        get :new
        expect(response).to redirect_to '/mypage'
      end
      it '302レスポンスを返すこと' do
        sign_in user
        get :new
        expect(response).to have_http_status '302'
      end
    end
    context 'ログインユーザーじゃなかった場合' do
      it 'loginページにリダイレクトすること' do
        get :new
        expect(response).to redirect_to '/login'
      end
      it '302リクエストを返すこと' do
        get :new
        expect(response).to have_http_status '302'
      end
    end
  end

  describe '#create' do
    context 'ユーザーがフォトグラファーだった場合' do
      before do
        @user = FactoryBot.create(:user, user_status: 'フォトグラファー')
      end
      it '写真を投稿し保存することできる' do
        photo_params = FactoryBot.attributes_for(:photo, user_id: @user.id)
        sign_in @user
        expect {
          post :create, params: { photo: photo_params }
        }.to change(@user.photos, :count).by(1)
      end
    end
    context 'フォトグラファーじゃかったら' do
      before do
        @user = FactoryBot.create(:user)
        @photo_params = FactoryBot.attributes_for(:photo)
      end
      it '302レスポンスを返すこと' do
        sign_in @user
        post :create, params: { photo: @photo_params }
        expect(response).to have_http_status '302'
      end
      it 'mypageにリダイレクトすること' do
        sign_in @user
        post :create, params: { photo: @photo_params }
        expect(response).to redirect_to '/mypage'
      end
    end
    context 'ログインユーザーじゃなかったら' do
      before do
        @photo_params = FactoryBot.attributes_for(:photo)
      end
      it '302レスポンスを返す' do
        post :create, params: { photo: @photo_params }
        expect(response).to have_http_status '302'
      end
      it 'loginページにリダイレクトすること' do
        post :create, params: { photo: @photo_params }
        expect(response).to redirect_to '/login'
      end
    end
  end
  describe '#edit' do
    context 'ユーザーがフォトグラファーだったら' do
      before do
        @user= FactoryBot.create(:user, user_status: 'フォトグラファー')
        @photo = FactoryBot.create(:photo, user_id: @user.id)
      end
      it '正常なレスポンスを返す' do
        sign_in @user
        get :edit, params: { id: @photo.id }
        expect(response).to be_successful
      end
      it '200レスポンスを返す' do
        sign_in @user
        get :edit, params: { id: @photo.id }
        expect(response).to have_http_status '200'
      end
    end
    context 'フォトグラファー本人ではなかったら' do
      before do
        @user = FactoryBot.create(:user)
        @other_user = FactoryBot.create(:user)
        @photo = FactoryBot.create(:photo, user_id: @other_user.id)
      end
      it '302レスポンスを返す' do
        sign_in @user
        get :edit, params: { id: @photo.id }
        expect(response).to have_http_status '302'
      end
      it 'mypageにリダイレクトする' do
        sign_in @user
        get :edit, params: { id: @photo.id }
        expect(response).to redirect_to '/mypage'
      end
    end
    context 'ユーザーが一般ユーザーだったら' do
      before do
        @user = FactoryBot.create(:user)
        @photo = FactoryBot.create(:photo, user_id: @user.id )
      end
      it '302レスポンスを返す' do
        sign_in @user
        get :edit, params: { id: @photo.id }
        expect(response).to have_http_status '302'
      end
      it 'mypageにリダイレクトする' do
        sign_in @user
        get :edit, params: { id: @photo.id }
        expect(response).to redirect_to '/mypage'
      end
    end
    context 'ログインユーザーじゃなかったら' do
      before do
        @user = FactoryBot.create(:user)
        @photo = FactoryBot.create(:photo, user_id: @user.id)
      end
      it '302レスポンスを返す' do
        get :edit, params: { id: @photo.id }
        expect(response).to have_http_status '302'
      end
      it 'login画面にリダイレクトする' do
        get :edit, params: { id: @photo.id }
        expect(response).to redirect_to '/login'
      end
    end
  end

  describe '#update' do
    before do
      @user = FactoryBot.create(:user, user_status: 'フォトグラファー')
      @photo = FactoryBot.create(:photo, user_id: @user.id)
      @photo_params = FactoryBot.attributes_for(:photo, caption: 'New Photo Caption')
    end
    context 'ユーザーがフォトグラファーだったら' do
      it 'photoを更新できること' do
        sign_in @user
        patch :update, params: { id: @photo.id, photo: @photo_params }
        expect(@photo.reload.caption).to eq 'New Photo Caption'
      end
    end
    context '本人じゃなかったら' do
      before do
        @other_user = FactoryBot.create(:user, user_status: 'フォトグラファー')
      end
      it 'photoを更新できないこと' do
        sign_in @other_user
        patch :update, params: { id: @photo.id, photo: @photo_params }
        expect(@photo.reload.caption).to_not eq 'New Photo Caption'
      end
      it 'mypageへリダイレクトすること' do
        sign_in @other_user
        patch :update, params: { id: @photo.id, photo: @photo_params }
        expect(response).to redirect_to '/mypage'
      end
    end
    context 'フォトグラファーじゃなかったら' do
      before do
        @user = FactoryBot.create(:user)
        @photo = FactoryBot.create(:photo, user_id: @user.id)
      end
      it '302レスポンスを返すこと' do
        sign_in @user
        patch :update, params: { id: @photo.id, photo: @photo_params }
        expect(response).to have_http_status '302'
      end
      it 'mypageにリダイレクトすること' do
        sign_in @user
        patch :update, params: { id: @photo.id, photo: @photo_params }
        expect(response).to redirect_to '/mypage'
      end
    end
    context 'ログインユーザーじゃなかったら' do
      it '302レスポンスを返すこと' do
        patch :update, params: { id: @photo.id, photo: @photo_params }
        expect(response).to have_http_status '302'
      end
      it 'loginページにリダイレクトすること' do
        patch :update, params: { id: @photo.id, photo: @photo_params }
        expect(response).to redirect_to '/login'
      end
    end
  end

  describe '#destroy' do
    before do
      @user = FactoryBot.create(:user, user_status: 'フォトグラファー')
      @photo = FactoryBot.create(:photo, user_id: @user.id)
    end
    describe 'ユーザーがフォトグラファーだった場合' do
      context 'ユーザーが写真の投稿主だったら' do
        it '写真を削除できること' do
          sign_in @user
          expect {
            delete :destroy, params: { id: @photo.id }
          }.to change(@user.photos, :count).by(-1)
        end
      end
      context '本人が投稿した写真じゃなかったら' do
        before do
          @other_user  = FactoryBot.create(:user)
          @other_user_photo = FactoryBot.create(:photo, user_id: @other_user.id)
        end
        it '写真を削除できないこと' do
          sign_in @user
          expect {
            delete :destroy, params: { id: @other_user_photo.id }
          }.to_not change(@other_user.photos, :count)
        end
        it 'mypageにリダイレクトすること' do
          sign_in @user
          delete :destroy, params: { id: @other_user_photo.id }
          expect(response).to redirect_to '/mypage'
        end
      end
    end
    context 'ログインユーザーじゃなかったら' do
      it '302レスポンスを返すこと' do
        delete :destroy, params: { id: @photo.id }
        expect(response).to have_http_status '302'
      end
      it 'loginページにリダイレクトすること' do
        delete :destroy, params: { id: @photo.id }
        expect(response).to redirect_to '/login'
      end
    end
  end
end
