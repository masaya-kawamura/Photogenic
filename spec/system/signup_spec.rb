require 'rails_helper'

RSpec.feature "新規登録のテスト", type: :feature do
  let!(:user) { FactoryBot.build(:user) }

  feature '新規登録成功のテスト' do
    background do
      visit new_user_registration_path
      click_link "Signup"
      fill_in 'user[name]', with: user.name
      fill_in 'user[email]', with: user.email
      fill_in 'user[area]', with: user.area
      fill_in 'user[password]', with: user.password
      fill_in 'user[password_confirmation]', with: user.password_confirmation
    end
    scenario '新規会員登録成功のテスト' do
      expect { click_button '新規登録' }.to change(User.all, :count).by(1)
    end
    scenario '新規会員登録後、マイページにリダイレクトする' do
      click_button '新規登録'
      expect(current_path).to eq '/'
      expect(page).to have_content '本人確認用のメールを送信しました。'
    end
  end

  feature '新規会員登録失敗のテスト' do
    background do
      visit new_user_registration_path
      fill_in 'user[name]', with: user.name
      fill_in 'user[email]', with: user.email
      fill_in 'user[area]', with: user.area
      fill_in 'user[password]', with: user.password
    end
    scenario '新規登録が失敗する' do
      expect { click_button '新規登録' }.to change(User.all, :count).by(0)
    end
    scenario 'バリデーションが表示される' do
      click_button '新規登録'
      expect(page).to have_content '確認用パスワードが内容とあっていません。'
    end
  end
end
