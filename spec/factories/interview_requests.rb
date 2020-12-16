FactoryBot.define do
  factory :interview_request do
    employer_profile
    freelancer_profile
    state { 0 }
  end
end
