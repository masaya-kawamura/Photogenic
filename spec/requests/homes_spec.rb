require 'rails_helper'

RSpec.describe HomesController, 'Homesコントローラーのテスト', type: :controller do
  describe "topアクション" do
    it '正常にレスポンスを返すこと' do
      get :top
      expect(response).to have_http_status '200'
    end
  end
end
