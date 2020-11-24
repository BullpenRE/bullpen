FactoryBot.define do
  factory :freelancer_software do
    freelancer_profile
    software
    license { true }
  end
end
