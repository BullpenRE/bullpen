FactoryBot.define do
  factory :freelancer_profile do
    association :user, :freelancer
    professional_title { Faker::Job.title }
    professional_years_experience { FreelancerProfile.professional_years_experiences.values.sample }
    professional_summary { Faker::Hipster.paragraph }
    curation { 'accepted' }
    draft { false }
    desired_hourly_rate { [100, 125, 150, 250].sample }

    trait :complete do
      after(:create) do |freelancer_profile, _|
        create(:freelancer_profile_education, freelancer_profile: freelancer_profile)
        create(:freelancer_profile_experience, freelancer_profile: freelancer_profile, start_year: 2012, end_year: 2018)
        create(:freelancer_profile_experience, freelancer_profile: freelancer_profile, start_year: 2018, end_year: Time.current.year)
        create(:freelancer_certification, freelancer_profile: freelancer_profile, certification: (Certification.all.sample || create(:certification)))

        real_estate_skill_ids = RealEstateSkill.pluck(:id).shuffle
        sector_ids = Sector.pluck(:id).shuffle
        software_ids = Software.pluck(:id).shuffle
        3.times {|index| create(:freelancer_real_estate_skill, freelancer_profile: freelancer_profile, real_estate_skill_id: real_estate_skill_ids[index] || create(:real_estate_skill).id) }
        3.times {|index| create(:freelancer_sector, freelancer_profile: freelancer_profile, sector_id: sector_ids[index] || create(:sector).id) }
        3.times {|index| create(:freelancer_software, freelancer_profile: freelancer_profile, software_id: software_ids[index] || create(:software).id) }
      end
    end
  end
end
