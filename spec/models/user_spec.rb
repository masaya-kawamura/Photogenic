# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User,'Userモデルに関するテスト' do
  describe '実際に保存してみる' do
    it "有効な入力内容の場合は保存されるか" do
      expect(FactoryBot.create(:user)).to be_valid
    end
  end
  context '空白バリデーションチェック' do
    it '名前の入力がない場合はバリデーションされ空白のエラ〜メッセージが表示される' do
      user = FactoryBot.build(:user, name: nil)
      user.valid?
      expect(user.errors[:name]).to include("が入力されていません。")
    end
    it 'メールアドレスが空白の場合はバリデーションされ空白のエラ＾メッセージが表示されるか' do
      user = FactoryBot.build(:user, email:nil)
      user.valid?
      expect(user.errors[:email]).to include('が入力されていません。')
    end
    it 'メールアドレスが重複している場合に、バリデーションされエラ〜メッセージが表示されるか' do
      user1 = FactoryBot.create(:user, email: 'yamada@example.com')
      user2 = FactoryBot.build(:user, email: 'yamada@example.com')
      user2.valid?
      expect(user2.errors[:email]).to include("は既に使用されています。")
    end
    it 'パスワードがない場合は無効である' do
      user = FactoryBot.build(:user, password: nil)
      user.valid?
      expect(user.errors[:password]).to include('が入力されていません。')
    end
    it 'パスワードと確認パスワードが一致しなかった場合は保存でできない' do
      expect(FactoryBot.build(:user, password:"password", password_confirmation: "passward")).to_not be_valid
    end
  end
end
