FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.unique.email }
    password { Faker::Internet.password(min_length: 8, max_length: 60) }
    location { 'New York, NY' }
    confirmed_at { Time.current }

    trait :unconfirmed do
      confirmed_at { nil }
    end

    trait :employer do
      role { 1 }
      phone_number { Faker::PhoneNumber.phone_number }
      first_name {'TetyanaEmpl'}
      email { 'tetyanaEmpl@gmail.com' }
      password { 'q1234567!Q' }
    end

    trait :freelancer do
      role { 0 }
      first_name {'TetyanaFree'}
      email { 'tetyanaFree@gmail.com' }
      password { 'q1234567!Q' }
    end

  end
end
