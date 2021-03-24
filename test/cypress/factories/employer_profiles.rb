FactoryBot.define do
  factory :employer_profile do
    association :user, :employer
    company_name { Faker::Company.name }
    company_website { Faker::Internet.domain_name }
    role_in_company { Faker::Job.title }
    employee_count { EmployerProfile.employee_counts.values.sample }
    category { EmployerProfile.categories.values.sample }
    motivation_one_time { [true, false].sample }
    motivation_ongoing_support { [true, false].sample }
    motivation_backfill { [true, false].sample }
    motivation_augment { [true, false].sample }
    motivation_other { [true, false].sample }
    # completed { false }

    # trait :complete do
      completed { true }

      after(:create) do |employer_profile, _|
        create(:interview_request, employer_profile: employer_profile)

        sector_ids = Sector.pluck(:id).shuffle
        3.times { |index| create(:employer_sector, employer_profile: employer_profile, sector_id: sector_ids[index] || create(:sector).id) }
      end
    # end
  end
end
