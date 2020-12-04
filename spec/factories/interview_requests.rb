FactoryBot.define do
  factory :interview_request do
    employer_profile { nil }
    freelancer_profile { nil }
    state { 1 }
  end
end
