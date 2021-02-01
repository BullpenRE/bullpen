FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.unique.email }
    password { Faker::Internet.password(min_length: 8, max_length: 60) }
    confirmed_at { Time.current }

    trait :unconfirmed do
      confirmed_at { nil }
    end

    trait :employer do
      role { 1 }
      phone_number { Faker::PhoneNumber.phone_number }
    end

    trait :freelancer do
      role { 0 }
    end
  end
end
