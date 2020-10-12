FactoryBot.define do
  factory :freelancer_profile_education do
    freelancer_profile { nil }
    institution { "MyString" }
    degree { 1 }
    course_of_study { "MyString" }
    graduation_year { 1 }
    currently_studying { false }
    description { "MyText" }
  end
end
