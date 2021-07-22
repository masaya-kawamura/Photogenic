require 'rails_helper'

RSpec.describe "フォトグラファーログイン後のテスト", type: :system do
  before do
    @user = FactoryBot.create(:user, user_status: 'フォトグラファー')
    @photographer = FactoryBot.create(:photographer, user_id: @user.id)
    visit new_user_session_path
    fill_in 'user[email]', with: @user.email
    fill_in 'user[password]', with: @user.password
    click_button 'ログイン'
  end

  it '投稿ページにアクセスできるか' do
    visit new_photo_path
    expect(page).to have_current_path "/photos/new"
  end

  describe '写真投稿のテスト' do
    it '有効な入力の場合には写真を投稿することができる' do
      visit new_photo_path
      attach_file "photo[photo_image]", "#{Rails.root}/spec/fixtures/post_photo.jpg"
      fill_in 'photo[genre]', with: '人物 風景 料理'
      fill_in 'photo[caption]', with: '写真投稿のテスト'
      click_button '写真を投稿'
      expect(page).to have_content '写真を投稿しました'
      expect(page).to have_content @photographer.name
      expect(page).to have_selector("img[src$='post_photo.jpg']")
    end
    it '写真の選択がない場合には投稿できない' do
      visit new_photo_path
      click_button '写真を投稿'
      expect(page).to have_current_path "/photos"
      expect(page).to have_content '写真を選択してください'
    end
  end
end
