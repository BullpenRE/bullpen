FactoryBot.define do
  factory :freelancer_profile_experience do
    freelancer_profile
    job_title { Faker::Company.profession }
    company { Faker::Company.name }
    description { Faker::Lorem.sentences }
    location { Faker::Address.city }
    start_month { 2 }
    start_year { 2008 }
    end_month { 2 }
    end_year { 2020 }
  end
end
