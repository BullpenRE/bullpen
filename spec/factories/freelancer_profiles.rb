FactoryBot.define do
  factory :freelancer_profile do
    association :user, :freelancer
    professional_title { Faker::Job.title }
    professional_summary { Faker::Hipster.paragraph }
    curation { 'pending' }
    draft { false }
    new_jobs_alert { true }
    desired_hourly_rate { [100, 125, 150, 250].sample }

    trait :complete do
      curation { 'accepted' }
      after(:create) do |freelancer_profile, _|
        create(:freelancer_profile_education, freelancer_profile: freelancer_profile)
        create(:freelancer_profile_experience, freelancer_profile: freelancer_profile, start_year: 2012, end_year: 2018)
        create(:freelancer_profile_experience, freelancer_profile: freelancer_profile, start_year: 2018, end_year: Time.current.year)
        create(:freelancer_certification, freelancer_profile: freelancer_profile, certification: (Certification.all.sample || create(:certification)))

        real_estate_skill_ids = RealEstateSkill.pluck(:id).shuffle
        sector_ids = Sector.pluck(:id).shuffle
        software_ids = Software.pluck(:id).shuffle
        3.times {|index| create(:freelancer_real_estate_skill, freelancer_profile: freelancer_profile, real_estate_skill_id: real_estate_skill_ids[index] || create(:real_estate_skill, description: "Real Estate Skill #{index}").id) }
        3.times {|index| create(:freelancer_sector, freelancer_profile: freelancer_profile, sector_id: sector_ids[index] || create(:sector, description: "Sector #{index}").id) }
        3.times {|index| create(:freelancer_software, freelancer_profile: freelancer_profile, software_id: software_ids[index] || create(:software, description: "Software #{index}").id) }
      end
    end
  end
end
