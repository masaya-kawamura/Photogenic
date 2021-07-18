# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Genre, 'Genreモデルのテスト' do
  subject { genre.valid? }

  let!(:genre) { build(:genre) }

  describe '実際に保存してみる' do
    it '有効なジャンルの場合は保存されるか' do
      is_expected.to eq true
    end
    it 'nameが空だった場合には保存できないようになっているか' do
      genre.name = ''
      is_expected.to eq false
    end
    it 'nameが重複していた場合には保存されない' do
      genre1 = Genre.create(name: 'ジャンル')
      genre2 = Genre.new(name: 'ジャンル')
      expect(genre2.valid?).to eq false
    end
  end
end
