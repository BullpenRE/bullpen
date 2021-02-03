FactoryBot.define do
  factory :review do
    employer_profile
    freelancer_profile
    rating { rand(Review::RATING_OPTIONS) }
    comments { Faker::Company.catch_phrase }
  end
end
