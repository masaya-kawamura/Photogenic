require 'rails_helper'

RSpec.feature "ログイン後のテスト（一般ユーザー）", type: :system do

  # let!(:user) { FactoryBot.create(:user) }

  before do
    @user = FactoryBot.create(:user)
    visit new_user_session_path
    fill_in 'user[email]', with: @user.email
    fill_in 'user[password]', with: @user.password
    click_button 'ログイン'
  end

  describe 'マイページのテスト' do
    before do
      visit mypage_path
    end
    it '表示の確認' do
      expect(page).to have_content '一般ユーザー'
      expect(page).to have_content 'フォロー中'
      expect(page).to have_content @user.name
      expect(page).to have_link 'フォトグラファー登録する'
    end
    it 'フォトグラファー登録するボタンを押下し登録画面に遷移する' do
      click_on 'フォトグラファー登録する'
      expect(page).to have_current_path '/photographers/new'
    end
  end

  describe '写真の詳細ページのテスト'  do
    before do
      @photographer_user = FactoryBot.create(:user, name: '写真家 太郎', email: 'photographer@example.com')
      @photo = FactoryBot.create(:photo, user_id: @photographer_user.id)
      FactoryBot.create(:photographer, user_id: @photographer_user.id)
      visit photo_path(@photo.id)
    end
    describe 'フォローボタンのテスト' do
      context 'フォローボタンを押下するとフォローすることができる', js: true do
        it 'フォトグラファーをフォローする' do
          click_button 'フォローする'
          expect(page).to have_content '1 フォロワー'
          expect(@photographer_user.follower.count).to eq 1
        end
      end
      context 'フォローを外すボタンを押下するとフォローが解除される', js: true do
        before do
          Relationship.create(follower_id: @user.id, followed_id: @photographer_user.id)
          visit photo_path(@photo.id)
        end
        it 'フォロー解除のテスト' do
          click_button 'フォローを外す'
          expect(page).to have_content '0 フォロワー'
          expect(@photographer_user.follower.count).to eq 0
        end
      end
    end

    describe '写真へのコメントのテスト' do
      context 'コメント投稿のテスト', js: true do
        it '有効な投稿の場合にはコメント投稿に成功する' do
          fill_in 'comment[comment]', with: 'コメントテスト'
          click_button 'コメントを送信'
          expect(page).to have_content 'コメントテスト'
          expect(@photo.comments.count).to eq 1
        end
      end
    end

    describe '写真へのいいねのテスト', js: true do
      before 'Goodボタンを押していいねを実行する' do
        click_on('Favorite')
      end
      it 'いいねされているか' do
        expect(page).to have_css 'a#unfavorite'
        expect(@photo.favorites.count).to eq 1
      end
      it 'いいねの取り消しができるか' do
        click_on('Unfavorit')
        expect(page).to have_css 'a#favorite'
        expect(@photo.favorites.count).to eq 0
      end
    end
  end
end
