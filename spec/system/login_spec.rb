require 'rails_helper'

RSpec.feature "ログインのテスト", type: :system do

  let(:user) { FactoryBot.create(:user) }

    before do
      visit new_user_session_path
    end

  describe 'ログイン画面の(new_user_session_path)テスト' do
    it '有効な会員の場合にはログインできるかのテスト' do
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
      expect(page).to have_content 'ログインしました'
      expect(page).to have_current_path mypage_path
    end
    it '無効な会員の場合にはログインできずにエラーメッセージが表示されるかのテスト' do
      fill_in 'user[email]', with: 'invalid_user@example.com'
      fill_in 'user[password]', with: 'invalid_user_password'
      click_button 'ログイン'
      expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
      expect(page).to have_current_path new_user_session_path
    end
  end
end