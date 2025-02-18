FactoryBot.define do
  factory :shop_bookmark do
    association :user
    association :shop
  end
end
