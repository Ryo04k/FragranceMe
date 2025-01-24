FactoryBot.define do
  factory :shop do
    name { Faker::Company.unique.name }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
    place_id { Faker::Number.unique.number(digits: 10).to_s }
    address { Faker::Address.full_address }
    phone_number { Faker::PhoneNumber.phone_number }
    web_site { Faker::Internet.url }
    rating { rand(1.0..5.0).round(1) }
    prefecture { "東京都" }
    opening_hours { "月曜日: 11時00分～20時00分" }
  end
end
