require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe '#mypage'do
    context 'ログイン済みユーザーの場合' do
      before do
        @user = FactoryBot.create(:user)
      end
      it '正常なレスポンスを返すこと' do
        sign_in @user
        get :mypage
        expect(response).to be_successful
      end
      it '200レスポンスを返すこと' do
        sign_in @user
        get :mypage
        expect(response).to have_http_status '200'
      end
    end
    context 'ログインしていないユーザーの場合'do
      it '302レスポンスを返すこと' do
        get :mypage
        expect(response).to have_http_status '302'
      end
      it '/login画面にリダイレクトすること' do
        get :mypage
        expect(response).to redirect_to "/login"
      end
    end
  end

  describe '#edit' do
    context 'ログインユーザーの場合' do
      before do
        @user = FactoryBot.create(:user)
      end
      it '正常なレスポンスを返すこと'do
        sign_in @user
        get :edit, params: { id: @user.id }
        expect(response).to be_successful
      end
    end
    context 'ログインしていないユーザーの場合' do
      it 'login画面にリダイレクトすること' do
        get :edit, params: { id: 1 }
        expect(response).to redirect_to "/login"
      end
    end
    context '本人以外がedit画面にアクセスした場合' do
      it 'マイページにリダレクトすること' do
        user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        sign_in user
        get :edit, params: { id: other_user.id }
        expect(response).to redirect_to '/mypage'
      end
    end
  end

  describe '#update' do
    context 'ユーザーの更新が本人だった場合' do
      before do
        @user = FactoryBot.create(:user)
      end
      it 'ユーザー情報を更新できること' do
        edit_user = FactoryBot.attributes_for(:user, name: '山田二郎')
        sign_in @user
        patch :update, params: { id: @user.id, user: edit_user }
        expect(@user.reload.name).to eq '山田二郎'
      end
    end
    context '更新が本人じゃなかった場合' do
      before do
        @user = FactoryBot.create(:user)
        @other_user = FactoryBot.create(:user)
      end
      it '登録情報を更新できないこと' do
        edit_user = FactoryBot.attributes_for(:user, name: '山田 二郎')
        sign_in @user
        patch :update, params: { id: @other_user.id, user: edit_user }
        expect(@other_user.reload.name).to eq '山田 太郎'
      end
    end
  end

  describe '#withdrawal_confirmation' do
    before  do
      @user = FactoryBot.create(:user)
    end
    context 'ログインユーザーの場合' do
      it '正常なレスポンスを返す' do
        sign_in @user
        get :withdrawal_confirmation
        expect(response).to be_successful
      end
    end
    context 'ログインユーザじゃなかった場合' do
      it 'login画面にリダイレクト' do
        get :withdrawal_confirmation
        expect(response).to redirect_to '/login'
      end
    end
  end

  describe '#destory' do
    context '本人だった場合' do
      before do
        @user = FactoryBot.create(:user)
      end
      it '退会処理が行えること' do
        sign_in @user
        expect {
          delete :destroy, params: { id: @user.id }
        }.to change(User, :count).by(-1)
      end
    end
    context '本人じゃない場合' do
      before do
        @user = FactoryBot.create(:user)
        @other_user = FactoryBot.create(:user)
      end
      it '退会処理が行えないこと' do
        sign_in @user
        expect {
          delete :destroy, params: { id: @other_user.id }
        }.to_not change(User, :count)
      end
      it 'mypageにリダイレクトすること' do
        sign_in @user
        delete :destroy, params: { id: @other_user }
        expect(response).to redirect_to '/mypage'
      end
    end
    context 'ログインユーザーじゃなかった場合' do
      it 'login画面にリダレクトすること' do
        delete :destroy, params: { id: 1 }
        expect(response).to redirect_to '/login'
      end
      it '302レスポンスを返すこと' do
        delete :destroy, params: { id: 1 }
        expect(response).to have_http_status '302'
      end
      it 'ユーザーを削除できないこと' do
        expect {
          delete :destroy, params: { id: 1 }
        }.to_not change(User, :count)
      end
    end
  end
end
