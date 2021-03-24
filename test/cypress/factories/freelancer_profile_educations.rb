FactoryBot.define do
  factory :freelancer_profile_education do
    freelancer_profile
    institution { Faker::Educator.university }
    degree { FreelancerProfileEducation.degrees.values.sample }
    course_of_study { Faker::Educator.subject }
    graduation_year { FreelancerProfileEducation::AVAILABLE_YEARS.to_a.sample }
    currently_studying { false }
    description { Faker::Hipster.paragraph }

    # trait :current do
    #   graduation_year { nil }
    #   currently_studying { true }
    # end
  end
end
