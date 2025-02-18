require 'rails_helper'

RSpec.describe "Map", type: :request  do
  describe "GET /shops/map" do
    it "GoogleMapの表示に成功すること" do
      get "/shops/map"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /shops/list" do
    before do
      @shop1 = create(:shop, latitude: 35.6803997, longitude: 139.7690174)
      @shop2 = create(:shop, latitude: 35.6903997, longitude: 139.7790174)
      @shop3 = create(:shop, latitude: 35.7003997, longitude: 139.7890174)
    end

    it "リクエストが成功すること" do
      get "/shops/list"
      expect(response).to have_http_status(:success)
    end

    it "JSON形式でレスポンスが返されること" do
      get list_shops_path, params: { latitude: 35.6803997, longitude: 139.7690174 }
      expect(response.content_type).to eq("application/json; charset=utf-8")
    end
  end
end
