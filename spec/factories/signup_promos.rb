FactoryBot.define do
  factory :signup_promo do
    description { Faker::Lorem.sentence }
    code { Faker::Lorem.word }
    user_type {signup_promo.user_type}
    enabled { Faker::Boolean }
  end
end
