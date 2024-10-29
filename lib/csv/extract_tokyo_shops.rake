require "csv"
require "open-uri"
require "set"

API_KEY = ENV["GOOGLE_API_KEY"]

namespace :Shop do
  desc "Fetch fragrance shops in Tokyo and save to CSV"
  task extract_fragrance_shops_to_csv: :environment do
    csv_file = "lib/fragrance_shops.csv"

    # 既存の店舗を Set に読み込む
    existing_shops = Set.new
    CSV.foreach(csv_file, headers: true) do |row|
      existing_shops.add(row["店名"])
    end

    # 新しい店舗を追加するための配列
    new_shops = []

    # 東京の主要エリアの座標
    tokyo_areas = [
      { name: "渋谷", lat: 35.6580, lng: 139.7016 }
    ]

    client = GooglePlaces::Client.new(API_KEY)

    tokyo_areas.each do |area|
      next_page_token = nil

      loop do
        shops = client.spots(area[:lat], area[:lng],
                             name: "フレグランス OR 香水 OR お香",
                             language: "ja",
                             types: [ "store", "shopping_mall", "department_store" ],
                             radius: 3000,
                             page_token: next_page_token)

        # もし shops が配列であれば、次のページトークンの取得を行う
        next_page_token = shops.next_page_token if shops.respond_to?(:next_page_token)

        shops.each do |shop|
          # 重複チェック
          next if existing_shops.include?(shop.name)

          begin
            # 各店舗の詳細情報を別途リクエスト
            details = client.spot(shop.place_id, fields: [ "formatted_phone_number" ])
            phone_number = details.formatted_phone_number || "情報なし"
          rescue => e
            puts "Error fetching details for #{shop.name}: #{e.message}"
            phone_number = "情報なし"
          end

          new_shops << [
            13,  # 東京都の都道府県ID
            shop.name,
            phone_number,
            false  # 香水体験のデフォルト値（APIからは取得できないため）
          ]

          existing_shops.add(shop.name)  # 新しく追加した店舗も重複チェック用のSetに追加
        end

        break unless next_page_token

        sleep(2)  # リクエスト間の待機を設定（2秒）
      end
    end

    # 新しい店舗のみをCSVに追加
    CSV.open(csv_file, "a") do |csv|
      new_shops.each do |shop|
        csv << shop
      end
    end

    puts "#{new_shops.size}件の新しい店舗情報を #{csv_file} に追加しました。"
  end
end
