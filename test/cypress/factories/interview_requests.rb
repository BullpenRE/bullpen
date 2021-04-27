FactoryBot.define do
  factory :interview_request do
    employer_profile
    freelancer_profile
    state { 'pending' }
    hide_from_freelancer { false }
    hide_from_employer { false }
    message { 'Cy Hello' }
  end
end
