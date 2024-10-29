# lib/tasks/get_shop_details.rake

require "csv" # csvファイルを操作するライブラリの読み込み
require "open-uri" # open-uriライブラリを読み込んでいる
API_KEY = ENV["GOOGLE_API_KEY"] # .envに記述しているAPIキーを代入

namespace :Shop do
  desc "Fetch and save shop details"
  task get_and_save_details: :environment do
    def get_place_id(phone_number)
      client = GooglePlaces::Client.new(API_KEY)
      spot = client.spots_by_query(phone_number).first
      spot.place_id if spot
    end

    def get_detail_data(shop)
      place_id = get_place_id(shop["電話番号"])

      if place_id
        existing_shop = Shop.find_by(place_id: place_id) # 　データベース内のShopテーブルを検索
        if existing_shop
          existing_shop.update!(
            has_experience: shop["体験"].to_s.downcase == "true"
            # 他の更新したいフィールドもここに追加
          )
          puts "既に保存済みです: #{shop['ショップ名']}"
          return nil
        end

        place_detail_query = URI.encode_www_form(
          place_id: place_id,
          language: "ja",
          key: API_KEY
        )
        # 　PlacesAPIのエンドポイントの作成
        place_detail_url = "https://maps.googleapis.com/maps/api/place/details/json?#{place_detail_query}"
        # APIから取得したデータをテキストデータ（JSON形式）で取得し、変数に格納
        place_detail_page = URI.open(place_detail_url).read
        # 　JSON形式のデータを、Rubyオブジェクトに変換
        place_detail_data = JSON.parse(place_detail_page)

        # 　取得したデータを保存するカラム名と同じキー名で、ハッシュ（result）に保存
        result = {}
        result[:name] = shop["店名"]
        result[:postal_code] = place_detail_data["result"]["address_components"].find { |c| c["types"].include?("postal_code") }&.fetch("long_name", nil)

        full_address = place_detail_data["result"]["formatted_address"]
        result[:address] = full_address.sub(/\A[^ ]+/, "")

        result[:phone_number] = place_detail_data["result"]["formatted_phone_number"]
        result[:opening_hours] = place_detail_data["result"]["opening_hours"]["weekday_text"].join("\n") if place_detail_data["result"]["opening_hours"].present?
        result[:latitude] = place_detail_data["result"]["geometry"]["location"]["lat"]
        result[:longitude] = place_detail_data["result"]["geometry"]["location"]["lng"]
        result[:place_id] = place_id
        result[:web_site] = place_detail_data["result"]["website"]
        result[:rating] = place_detail_data["result"]["rating"]

        result
      else
        puts "詳細情報が見つかりませんでした。"
        nil
      end
    end

    def photo_reference_data(shop_data)
      if shop_data
        place_id = shop_data[:place_id]
        place_detail_query = URI.encode_www_form(
          place_id: place_id,
          language: "ja",
          key: API_KEY
        )
        place_detail_url = "https://maps.googleapis.com/maps/api/place/details/json?#{place_detail_query}"
        place_detail_page = URI.open(place_detail_url).read
        place_detail_data = JSON.parse(place_detail_page)

        photos = place_detail_data["result"]["photos"] if place_detail_data["result"]["photos"].present?
        photo_references = []

        if photos.present?
          photos.take(4).each do |photo|
            photo_references << photo["photo_reference"]
          end
          photo_references
        else
          nil
        end
      else
        puts "詳細データがありません"
        nil
      end
    end

    csv_file = "lib/fragrance_shops.csv"
    CSV.foreach(csv_file, headers: true) do |row|
      shop_data = get_detail_data(row)
      if shop_data
          # 都道府県IDとカテゴリIDを取得してデータハッシュに追加
          shop_data.merge!(
            prefecture: row["都道府県ID"].to_i,
            has_experience: row["体験"].to_s.downcase == "true"
          )
        shop = Shop.create!(shop_data)
        puts "Shopを保存しました: #{row['ショップ名']}"
        # 画像参照情報の取得
        photo_references = photo_reference_data(shop_data)
        if photo_references.present?
          photo_references.each do |photo_reference|
            # 画像をShopImageモデルに保存
            ShopImage.create!(shop: shop, image: photo_reference)
          end
          puts "画像を保存しました: #{row['ショップ名']}"
        else
          puts "画像の保存に失敗しました: #{row['ショップ名']}"
        end

        puts "----------"
      else
        puts "Shopの保存に失敗しました: #{row['ショップ名']}"
      end
    end
  end
end
