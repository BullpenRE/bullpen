FactoryBot.define do
  factory :interview_request do
    employer_profile
    freelancer_profile
    # state { InterviewRequest.states.values.sample }
    state { 'pending' }
    hide_from_freelancer { false }
    hide_from_employer { false }
    # message { Rack::Test::UploadedFile.new('test/cypress/support/assets/interview_request_message.html', 'text/html') }
    message { 'Cy Hello' }
  end
end
