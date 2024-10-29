namespace :Shop do
  desc "Fetch fragrance shops in Tokyo and save to CSV"
  task extract_fragrance_shops_to_csv: :environment do
    csv_file = "lib/fragrance_shops.csv"
    API_KEY = ENV["GOOGLE_API_KEY"]

    # 既存の店舗を Set に読み込む
    existing_shops = Set.new
    if File.exist?(csv_file)
      CSV.foreach(csv_file, headers: true) do |row|
        existing_shops.add(row["店名"])
      end
    end

    new_shops = []

    tokyo_areas = [
      { name: "新宿", lat: 35.6895, lng: 139.7004 }
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

        next_page_token = shops.next_page_token if shops.respond_to?(:next_page_token)

        shops.each do |shop|
          next if existing_shops.include?(shop.name)

          phone_number = "情報なし"
          begin
            details = client.spot(shop.place_id, fields: [ "formatted_phone_number" ])
            phone_number = details.formatted_phone_number || "情報なし"
          rescue => e
            puts "Error fetching details for #{shop.name}: #{e.message}"
          end

          new_shops << [
            13,  # 都道府県ID
            shop.name,
            phone_number,
            false  # 香水体験のデフォルト値
          ]

          # 電話番号を国際形式にフォーマットするメソッド
          def format_phone_number(phone_number)
            return "情報なし" if phone_number == "情報なし"

            # 日本の国番号 +81 を付与
            formatted_number = phone_number.gsub(/^0/, "")  # 最初の0を削除
            "+81 #{formatted_number}"  # 国際番号形式に変換
          end

          existing_shops.add(shop.name)
        end

        break unless next_page_token

        sleep(2)
      end
    end

    # ヘッダーがない場合は追加
    CSV.open(csv_file, "a+") do |csv|
      csv << [ "都道府県ID", "店名", "電話番号", "香水体験" ] if csv.count.zero?
      new_shops.each do |shop|
        csv << shop
      end
    end

    puts "#{new_shops.size}件の新しい店舗情報を #{csv_file} に追加しました。"
  end
end
