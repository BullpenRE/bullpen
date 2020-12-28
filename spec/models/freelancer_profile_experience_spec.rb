require 'rails_helper'

RSpec.describe FreelancerProfileExperience, type: :model do
  let(:user)  { FactoryBot.create(:user) }
  let!(:freelancer_profile) { FactoryBot.create(:freelancer_profile, user: user) }
  let!(:freelancer_profile_experience) { create(:freelancer_profile_experience, freelancer_profile: freelancer_profile) }

  it 'factory works' do
    expect(freelancer_profile_experience).to be_valid
  end

  context 'Validations' do
    it { is_expected.to validate_presence_of(:job_title) }
    it { is_expected.to validate_presence_of(:company) }
    it { is_expected.to validate_presence_of(:location) }
    it { is_expected.to validate_presence_of(:description) }

    context 'custom validation in #end_date_is_after_start_date' do
      it 'prevents object create if ending date occur before the starting date' do
        expect { FactoryBot.create(:freelancer_profile_experience,
                                   freelancer_profile: freelancer_profile,
                                   start_year: 2015,
                                   end_year: 2014) }
          .to raise_error(ActiveRecord::RecordInvalid)
                .with_message(/End date cannot occur before the starting date/)
      end

      it 'prevents object update if new ending year occur before the starting year' do
        expect { freelancer_profile_experience.update!(start_month: 2, start_year: 2015, end_month: 2, end_year: 2014) }
          .to raise_error(ActiveRecord::RecordInvalid)
                .with_message(/End date cannot occur before the starting date/)
      end

      it 'prevents object update if new ending month occur before the starting month and year is the same' do
        expect { freelancer_profile_experience.update!(start_month: 2, start_year: 2015, end_month: 1, end_year: 2015) }
          .to raise_error(ActiveRecord::RecordInvalid)
                .with_message(/End date cannot occur before the starting date/)
      end

      it 'allows the update if dates are the same' do
        expect { freelancer_profile_experience.update!(start_month: 2, start_year: 2015, end_month: 2, end_year: 2015) }
          .not_to raise_error
      end

      it 'allows the update if end_month and end_year absent' do
        expect { freelancer_profile_experience.update!(start_month: 2, start_year: 2015, end_month: nil, end_year: nil) }
          .not_to raise_error
      end

      it 'allows the update if all dates absent' do
        expect { freelancer_profile_experience.update!(start_month: nil, start_year: nil, end_month: nil, end_year: nil) }
          .not_to raise_error
      end

      it 'allows the object create if all dates absent' do
        expect { FactoryBot.create(:freelancer_profile_experience,
                                   freelancer_profile: freelancer_profile,
                                   start_month: nil,
                                   start_year: nil,
                                   end_month: nil,
                                   end_year: nil) }.not_to raise_error
      end
    end
  end

  context 'Relationships' do
    it 'belongs_to a freelancer_profile' do
      expect(freelancer_profile_experience.freelancer_profile).to eq(freelancer_profile)
    end
  end

  context 'Methods' do
    it '#update_start_date' do
      freelancer_profile_experience.update(start_month: 2, start_year: 2015)
      expect(freelancer_profile_experience.start_date).to eq Date.strptime('2015-2', '%Y-%m')
    end

    it '#update_end_date' do
      freelancer_profile_experience.update(end_month: 2, end_year: 2020)
      expect(freelancer_profile_experience.end_date).to eq Date.strptime('2020-2', '%Y-%m')
    end

    it '#description_paragraphs' do
      freelancer_profile_experience.update(description: "Some point 1\n\nSome point 2\nSome point 3")
      expect(freelancer_profile_experience.description_paragraphs).to eq(['Some point 1', 'Some point 2', 'Some point 3'])
      freelancer_profile_experience.update(description: "A ")
      expect(freelancer_profile_experience.reload.description_paragraphs).to eq(['A '])
    end
  end
end
