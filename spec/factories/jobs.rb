FactoryBot.define do
  factory :job do
    user
    title { Faker::Job.title }
    short_description { Faker::Company.catch_phrase }
    position_length { Job::position_lengths.values.sample }
    hours_needed { Job::hours_neededs.values.sample }
    daytime_availability_required { [true, false].sample }
    required_experience { Job::required_experiences.values.sample }
    required_regional_knowledge { Faker::Company.bs }
    relevant_job_details { Faker::Company.bs }
    state { 0 }

    trait :complete do
      after(:create) do |job, _|
        (rand(4) + 1).times do
          create :job_question, job: job
        end
        (rand(4) + 1).times do
          create :job_software, job: job
        end
        (rand(4) + 1).times do
          create :job_skill, job: job
        end
        (rand(4) + 1).times do
          create :job_sector, job: job
        end
      end
    end
  end
end
