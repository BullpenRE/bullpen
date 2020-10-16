FactoryBot.define do
  factory :freelancer_profile_education do
    freelancer_profile
    institution { Faker::Educator.university }
    degree { 1 }
    course_of_study { Faker::Educator.subject }
    graduation_year { 2011 }
    currently_studying { false }
    description { Faker::Lorem.sentences }
  end
end
