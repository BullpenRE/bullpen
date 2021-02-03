FactoryBot.define do
  factory :review do
    employer_profile
    freelancer_profile
    rating { rand(1..5) }
    comments { Faker::Company.catch_phrase }
  end
end
