# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rate, 'Rateモデルのテスト' do
  subject {rate.valid? }

  let(:user) { create(:user) }
  let(:photo) { create(:photo, user_id: user.id) }
  let!(:rate) { build(:rate, user_id: user.id, photo_id: photo.id) }

  describe '実際に保存してみる' do
    it '有効な投稿内容の場合は保存できるか' do
      is_expected.to eq true
    end
  end
  describe 'バリデーションのテスト' do
    context 'rateカラムに関するテスト' do
      it 'rateが空だった場合には保存できないようになっている' do
        rate.rate = nil
        is_expected.to eq false
      end
    end
    context 'commentカラムに関するテスト' do
      it 'rate.commentが400文字を超えていたら保存できないようになっている' do
        rate.comment = Faker::Lorem.characters(number: 401)
        is_expected.to eq false
      end
    end
  end
end
