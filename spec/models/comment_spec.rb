# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, 'Commentモデルのテスト' do
  subject { comment.valid? }

  let(:user) { create(:user) }
  let(:photo) { create(:photo, user_id: user.id) }
  let!(:comment) { build(:comment, user_id: user.id, photo_id: photo.id) }

  describe '実際に保存してみる' do
    it '有効な投稿内容の場合には保存されるか' do
      is_expected.to eq true
    end
  end

  describe 'バリデーションのテスト' do
    it 'commentが未入力の場合には保存できない' do
      comment.comment = ''
      is_expected.to eq false
    end
    it 'commentが140文字を超えていたら保存できない' do
      comment.comment = Faker::Lorem.characters(number: 141)
      is_expected.to eq false
    end
  end
end
