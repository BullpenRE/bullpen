FactoryBot.define do
  factory :freelancer_profile_experience do
    freelancer_profile
    job_title { Faker::Company.profession }
    company { Faker::Company.name }
    description { Faker::Hipster.paragraph }
    location { Faker::Address.city }
    current_job { false }
    start_month { (1..12).to_a.sample }
    start_year { 3.years.ago.year }
    end_month { (1..12).to_a.sample }
    end_year { 1.year.ago.year }

    trait :current do
      current_job { true }
      end_month { nil }
      end_year { nil }
    end
  end
end
