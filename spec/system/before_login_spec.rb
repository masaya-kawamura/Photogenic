require 'rails_helper'

RSpec.describe "before_login", type: :system do
  let(:user) { FactoryBot.create(:user) }

  describe 'ログイン前のテスト' do
    describe 'トップ画面(root_path)のテスト' do
      before do
        visit root_path
      end

      it 'トップページにリンクが正しく設置されているかのテスト' do
        expect(page).to have_link '', href: root_path
        expect(page).to have_link '', href: photographers_path
        expect(page).to have_link '', href: photos_path
        expect(page).to have_link '', href: new_user_registration_path
        expect(page).to have_link '', href: new_user_session_path
      end
    end

    describe 'フォトグラファー一覧画面(photographers_path)のテスト' do
      before do
        @photographer = FactoryBot.create(:photographer, user_id: user.id, public_status: true)
        visit photographers_path
      end

      it 'urlが正しいかのテスト' do
        expect(page).to have_current_path '/photographers'
      end
      it 'フォトグラファーのプロフィール画像と名前が表示されているかのテスト' do
        expect(page).to have_selector("img[src$='photographer-profile-image.jpg']")
        expect(page).to have_content @photographer.name
      end
      it 'フォトグラファープロフィールページへのリンクが設置されているかのテスト' do
        expect(page).to have_link '', href: photographer_path(@photographer.id)
      end
      context '公開設定falseのフォトグラファーの場合' do
        before do
          FactoryBot.create(:user)
          @private_photographer = FactoryBot.create(
            :photographer,
            user_id: user.id,
            name: '非公開フォトグラファー',
            public_status: false
          )
        end

        it '一覧画面に表示されない' do
          expect(page).not_to have_content @private_photographer.name
        end
      end
    end

    describe 'フォトグラファー詳細ページのテスト' do
      before do
        @photographer = FactoryBot.create(:photographer, user_id: user.id, public_status: true)
        @photo = FactoryBot.create(:photo, user_id: user.id)
        visit photographer_path(@photographer.id)
      end

      it 'フォトグラファーのプロフィール写真とカバー写真が表示されている' do
        expect(page).to have_selector("img[src$='photographer-profile-image.jpg']")
        expect(page).to have_selector("img[src$='cover-image.jpg']")
        expect(page).to have_content @photographer.name
        expect(page).to have_content @photographer.introduction
      end
      it 'フォトグラファーの写真が表示されている' do
        expect(page).to have_selector("img[src$='photo.jpg']")
      end
    end

    describe '写真一覧画面のテスト' do
      before do
        @photographer = FactoryBot.create(:photographer, user_id: user.id)
        @photo = FactoryBot.create(:photo, user_id: user.id)
        visit photos_path
      end

      it 'urlが正しいかのテスト' do
        expect(page).to have_current_path '/photos'
      end
      it '写真が正しく表示されているか' do
        expect(page).to have_selector("img[src$='photo.jpg']")
      end
      it '写真のリンク正しく設置されているか' do
        expect(page).to have_link '', href: photo_path(@photo.id)
      end
    end

    describe '写真詳細画面のテスト' do
      before do
        @photographer = FactoryBot.create(:photographer, user_id: user.id)
        @photo = FactoryBot.create(:photo, user_id: user.id)
        visit photo_path(@photo.id)
      end

      it '投稿写真、投稿者、投稿者の名前が正常に表示されるか' do
        expect(page).to have_selector("img[src$='photographer-profile-image.jpg']")
        expect(page).to have_content @photographer.name
        expect(page).to have_selector("img[src$='photo.jpg']")
      end
      it '非ログイン時に、コメント入力フォームは表示しない' do
        expect(page).not_to have_field 'comment[comment]'
      end
      it '非ログイン時に評価入力フォームは表示されない' do
        click_on '評価'
        expect(page).not_to have_field 'rate[comment]'
      end
      context '非ログイン時のフォローといいねボタンのテスト' do
        it 'フォローボタンをクリックするとlogin画面に遷移' do
          click_on 'フォローする'
          expect(page).to have_current_path '/login'
        end
        it 'いいねボタンをクリックすると「ログインが必要ですのメッセージ' do
          click_on('Favorite')
          expect(page).to have_content 'いいねにはログインが必要です'
        end
      end
    end
  end
end
