FactoryBot.define do
  factory :contract do
    freelancer_profile
    employer_profile
    title { Faker::Job.title }
    contract_type { 0 }
    pay_rate { 150 }
    state { 'pending' }
    job_description { Faker::Company.bs }
    hide_from_freelancer { false }
    hide_from_employer { false }

    # trait :with_payment_account do
      after(:create) do |contract, _evaluator|
        contract.update(payment_account_id: create(:payment_account, employer_profile: contract.employer_profile).id)
      end
    # end

    # trait :with_job do
      after(:create) do |contract, _evaluator|
        create(:job, employer_profile: contract.employer_profile, title: contract.title, short_description: contract.job_description, contract_type: contract.contract_type)
      end
    # end
  end
end
