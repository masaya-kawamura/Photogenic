# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Photo, 'Photoモデルのテスト' do
  subject { photo.valid? }

  let(:user) { create(:user) }
  let!(:photo) { build(:photo, user_id: user.id) }

  describe '実際に保存してみる' do
    it '投稿内容が有効な場合は保存されるか' do
      is_expected.to eq true
    end
  end
  describe 'バリデーションのテスト' do
    context 'photo_imageカラムのテスト' do
      it '写真が選択されて以内場合は保存できない' do
        photo.photo_image = nil
          is_expected.to eq false
      end
    end
    context 'captionカラムのテスト' do
      it 'captionが250文字以内の場合は保存できる' do
        is_expected.to eq true
      end
      it 'captionが250文字を超えている場合は保存できない' do
        photo.caption = Faker::Lorem.characters(number: 251)
        is_expected.to eq false
      end
    end
  end
  describe 'アソシエーションのテスト' do
    context 'Userモデルのとの関係' do
      it 'N:1になっている' do
        expect(Photo.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
  end
end
