require "csv"
require "open-uri"
API_KEY = ENV["GOOGLE_API_KEY"]

namespace :Shop do
  desc "Fetch and save shop details"
  task get_and_save_details: :environment do
    def normalize_phone(phone_number)
      raw = phone_number.to_s.strip
      return { raw: nil, domestic: nil } if raw.blank?

      digits = raw.gsub(/\D/, "")
      domestic = if digits.start_with?("81")
                   "0#{digits[2..]}"
                 elsif digits.start_with?("0")
                   digits
                 end

      {
        raw: raw,
        domestic: domestic
      }
    end

    def find_place_id_by_text_query(query)
      return nil if query.blank?

      find_place_query = URI.encode_www_form(
        input: query,
        inputtype: "textquery",
        language: "ja",
        fields: "place_id,name,formatted_address",
        key: API_KEY
      )
      find_place_url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?#{find_place_query}"
      find_place_response = URI.open(find_place_url).read
      find_place_data = JSON.parse(find_place_response)

      return nil unless find_place_data["status"] == "OK"

      find_place_data["candidates"]&.first&.fetch("place_id", nil)
    rescue StandardError => e
      puts "place_id検索でエラー: query=#{query} error=#{e.class} #{e.message}"
      nil
    end

    def get_place_id(shop)
      name = shop["店名"].to_s.strip
      phone = normalize_phone(shop["電話番号"])

      queries = [
        [ name, phone[:raw] ].compact.join(" "),
        phone[:domestic],
        name
      ].map(&:to_s).map(&:strip).reject(&:blank?).uniq

      queries.each do |query|
        place_id = find_place_id_by_text_query(query)
        return place_id if place_id.present?
      end

      nil
    end

    def get_detail_data(shop)
      place_id = get_place_id(shop)
      return :not_found unless place_id

      existing_shop = Shop.find_by(place_id: place_id)
      if existing_shop
        existing_shop.update!(
          has_experience: shop["体験"].to_s.downcase == "true"
        )
        return :already_exists
      end

      place_detail_query = URI.encode_www_form(
        place_id: place_id,
        language: "ja",
        key: API_KEY
      )
      # PlacesAPIのエンドポイントの作成
      place_detail_url = "https://maps.googleapis.com/maps/api/place/details/json?#{place_detail_query}"
      place_detail_page = URI.open(place_detail_url).read
      # JSON形式のデータを、Rubyオブジェクトに変換
      place_detail_data = JSON.parse(place_detail_page)
      return :not_found unless place_detail_data["status"] == "OK"

      # 取得したデータを保存するカラム名と同じキー名で、ハッシュ（result）に保存
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
    rescue StandardError => e
      puts "詳細情報取得でエラー: 店名=#{shop['店名']} error=#{e.class} #{e.message}"
      :not_found
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
        return nil unless place_detail_data["status"] == "OK"

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
      if shop_data.is_a?(Hash)
        # 都道府県IDとカテゴリIDを取得してデータハッシュに追加
        shop_data.merge!(
          prefecture: row["都道府県ID"].to_i,
          has_experience: row["体験"].to_s.downcase == "true"
        )
        shop = Shop.create!(shop_data)
        puts "Shopを保存しました: #{row['店名']}"
        # 画像参照情報の取得
        photo_references = photo_reference_data(shop_data)
        if photo_references.present?
          photo_references.each do |photo_reference|
            # 画像をShopImageモデルに保存
            ShopImage.create!(shop: shop, image: photo_reference)
          end
          puts "画像を保存しました: #{row['店名']}"
        else
          puts "画像の保存に失敗しました: #{row['店名']}"
        end

        puts "----------"
      elsif shop_data == :already_exists
        puts "既に保存済みです: #{row['店名']}"
      elsif shop_data == :not_found
        puts "詳細情報が見つかりませんでした: #{row['店名']} / #{row['電話番号']}"
      else
        puts "Shopの保存に失敗しました: #{row['店名']}"
      end
    end
  end
end
