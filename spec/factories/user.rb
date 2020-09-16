FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 6, max_length: 60) }
  end
end
