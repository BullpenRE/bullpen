FactoryBot.define do
  factory :signup_promo do
    description { Faker::Lorem.sentence }
    code { Faker::Lorem.word }
    user_type {0 || 1 || 2}
    expires { Faker::Date.between(from: 2.days.ago, to: Date.today) }
  end
end
