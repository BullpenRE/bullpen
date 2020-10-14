FactoryBot.define do
  factory :employer_profile do
    user
    company_name { Faker::Company.name }
    company_website { Faker::Internet.domain_name }
    role_in_company { Faker::Job.title }
  end
end
