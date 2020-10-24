FactoryBot.define do
  factory :job do
    user
    title { Faker::Job.title }
    short_description { Faker::Company.catch_phrase }
    position_length { Job::position_lengths.values.sample }
    daytime_availability_required { [true, false].sample }
    required_experience { Job::required_experiences.values.sample }
    relevant_job_details { Faker::Company.bs }
    draft { false }
  end
end
