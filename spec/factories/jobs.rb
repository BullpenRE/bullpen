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
    state { Job.states.values.sample }
    job_announced { false }
    contract_type { 0 }
    pay_range_low { 100 }
    pay_range_high { 150 }

    trait :retainer do
      contract_type { 3 }
      pay_range_low { 7000 }
      pay_range_high { nil }
    end
  end
end
