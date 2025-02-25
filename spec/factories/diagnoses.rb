FactoryBot.define do
  factory :diagnosis do
    user
    fragrance
    diagnosis_date { Time.current }
  end
end
