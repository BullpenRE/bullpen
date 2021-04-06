FactoryBot.define do
  factory :signup_promo do
    description { Faker::Lorem.sentence }
    code { Faker::Lorem.word }
    user_type { 2 }
    expires { rand(2.days.ago..3.days.from_now) }

    trait :employer do
      user_type { 0 }
    end

    trait :freelancer do
      user_type { 1 }
    end
  end
end
