require 'rails_helper'

RSpec.describe "フォトグラファー登録のテスト", type: :system do
  before do
    @user = FactoryBot.create(:user)
    visit new_user_session_path
    fill_in 'user[email]', with: @user.email
    fill_in 'user[password]', with: @user.password
    click_button 'ログイン'
  end

  describe 'フォトグラファー新規登録のテスト' do
    let(:photographer) { FactoryBot.build(:photographer) }

    before '新規登録のテスト' do
      visit new_photographer_path
      fill_in 'photographer[name]', with: photographer.name
      fill_in 'photographer[area]', with: photographer.area
      fill_in 'photographer[genre]', with: '人物 風景 料理'
      fill_in 'photographer[introduction]', with: photographer.introduction
      fill_in 'photographer[instagram_url]', with: photographer.instagram_url
      fill_in 'photographer[facebook_url]', with: photographer.facebook_url
    end

    it '有効な入力の場合には新規登録ができる' do
      click_button '登録を完了する'
      expect(page).to have_current_path mypage_path
      expect(page).to have_content 'フォトグラファー登録が完了しました'
      expect(page).to have_content 'プロフィールページを見る'
    end
    it 'フォトグラファーネーム欄が入力されていなければ登録ができない' do
      visit new_photographer_path
      fill_in 'photographer[name]', with: ''
      click_button '登録を完了する'
      expect(page).to have_current_path '/photographers'
      expect(page).to have_content 'フォトグラファーネームを入力してください'
    end
  end
end
