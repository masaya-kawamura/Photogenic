# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Photographer, 'Photographerモデルに関するテスト' do
  describe 'バリデーションのテスト' do
    subject { photographer.valid? }

    let(:user) { FactoryBot.create(:user) }
    let!(:photographer) { FactoryBot.build(:photographer, user_id: user.id) }

    context 'nameカラム' do
      it '空欄ではないこと' do
        photographer.name = ''
        is_expected.to eq false
      end
    end

    context 'introductionカラム'
    it '250文字を超えた場合は保存できず、エラ〜メッセージが表示される' do
      photographer.introduction = Faker::Lorem.characters(number: 251)
      photographer.valid?
      expect(photographer.errors[:introduction]).to include('は250文字以内で入力してください')
    end
  end
end
