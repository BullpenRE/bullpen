FactoryBot.define do
  factory :contract do
    freelancer_profile
    employer_profile
    title { Faker::Job.title }
    contract_type { 0 }
    pay_rate { 150 }
    state { Contract.states.values.sample }
    job_description { Faker::Company.bs }

    trait :with_job do
      job
      after(:create) do |contract, _evaluator|
        contract.update(employer_profile_id: contract.job.user.employer_profile.id)
        contract.update(title: contract.job.title)
        contract.update(job_description: contract.job.short_description)
        contract.update(contract_type: contract.job.contract_type)
      end
    end
  end
end
