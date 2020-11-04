FactoryBot.define do
  factory :freelancer_certification do
    freelancer_profile
    certification
    description { 'temp' }
    earned { 1.day.ago }
    after(:create) do |freelancer_certification|
      if freelancer_certification.certification.custom? && freelancer_certification.description == 'temp'
        freelancer_certification.update(description: Faker::Company.unique.bs)
      else
        freelancer_certification.update(description: freelancer_certification.certification.description)
      end
    end
  end
end
