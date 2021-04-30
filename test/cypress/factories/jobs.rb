FactoryBot.define do
  factory :job do
    employer_profile
    title { Faker::Job.title }
    short_description { Faker::Company.catch_phrase }
    position_length { Job::position_lengths.values.sample }
    hours_needed { Job::hours_neededs.values.sample }
    time_zone { 0 }
    daytime_availability_required { [true, false].sample }
    required_experience { Job::required_experiences.values.sample }
    required_regional_knowledge { Faker::Company.bs }
    relevant_details { Faker::Company.bs }
    job_announced { false }
    contract_type { 0 }
    pay_range_low { 100 }
    pay_range_high { 150 }
    state { 'posted' }

    after(:create) do |job, _|

      skill_ids = Skill.pluck(:id).shuffle
      sector_ids = Sector.pluck(:id).shuffle
      software_ids = Software.pluck(:id).shuffle
      3.times {|index| create(:job_skill, job: job, skill_id: skill_ids[index] || create(:skill, description: "Skill #{index}").id) }
      3.times {|index| create(:job_sector, job: job, sector_id: sector_ids[index] || create(:sector, description: "Sector #{index}").id) }
      3.times {|index| create(:job_software, job: job, software_id: software_ids[index] || create(:software, description: "Software #{index}").id) }
    end
  end
end
