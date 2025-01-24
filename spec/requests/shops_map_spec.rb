require 'rails_helper'

RSpec.describe "Map", type: :request  do

  before do
    ENV["BASIC_AUTH_USER"] = "username"
    ENV["BASIC_AUTH_PASSWORD"] = "password"
  end

  describe "GET /shops/map" do
    it "GoogleMapの表示に成功すること" do
      get "/shops/map", headers: { "HTTP_AUTHORIZATION" => "Basic " + Base64.encode64("username:password") }
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /shops/list" do
    let(:latitude) { 35.6803997 }
    let(:longitude) { 139.7690174 }

    before do
      create_list(:shop, 1, latitude: latitude, longitude: longitude, place_id: "1", prefecture: "東京都")
    end

    it "周辺ショップ情報の取得に成功すること" do
      get "/shops/list", params: { latitude: latitude, longitude: longitude } , headers: { "HTTP_AUTHORIZATION" => "Basic " + Base64.encode64("username:password") }
      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq("application/json; charset=utf-8")

      json_response = JSON.parse(response.body)

      expect(json_response.size).to eq(1)

      expect(json_response.first).to have_key("name")
      expect(json_response.first).to have_key("latitude")
      expect(json_response.first).to have_key("longitude")
    end
  end
end
