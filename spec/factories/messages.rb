FactoryBot.define do
  factory :message do
    association :from_user, factory: :user
    association :to_user, factory: :user
    description { Rack::Test::UploadedFile.new('spec/support/assets/sample_message_description.html', 'text/html') }
  end
end
