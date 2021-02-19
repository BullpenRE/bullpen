require 'rails_helper'

RSpec.describe JobApplication, type: :model do
  let(:job) { FactoryBot.create(:job) }
  let!(:freelancer_profile) { FactoryBot.create(:freelancer_profile) }
  let!(:job_application) { FactoryBot.create(:job_application, job: job, template: true, freelancer_profile: freelancer_profile) }
  let(:job_application_with_attachments) { FactoryBot.create(:job_application, :with_attachments) }

  it 'factory works' do
    expect(job_application).to be_valid
    expect(job_application_with_attachments).to be_valid
    expect(job_application_with_attachments.work_samples.attached?).to be_truthy
    expect(job_application_with_attachments.cover_letter).to_not be_blank
  end

  context 'Validations' do
    it 'the combination of job_id and employer_profile_id is unique' do
      duplicate = FactoryBot.create(:job_application)
      duplicate.job_id = job_application.job_id
      expect(duplicate).to be_valid
      duplicate.freelancer_profile_id = job_application.freelancer_profile_id
      expect(duplicate).to_not be_valid
    end

    it 'pbid_amount must be either nil or greater than or equal to zero' do
      job_application.bid_amount = nil
      expect(job_application).to be_valid
      job_application.bid_amount = 0
      expect(job_application).to be_valid
      job_application.bid_amount = -1
      expect(job_application).to_not be_valid
    end

    describe 'whenever a template is set to true' do
      it 'on create, it is set to false for all other job_applications for the same freelancer' do
        expect(job_application.template).to be_truthy
        FactoryBot.create(:job_application, freelancer_profile: freelancer_profile, template: true)
        expect(job_application.reload.template).to be_falsey
      end
      it 'on update, it is set to false for all other job_applications' do
        new_application_same_user = FactoryBot.create(:job_application, freelancer_profile: freelancer_profile, template: false)
        expect(job_application.template).to be_truthy
        new_application_same_user.update(template: true)
        expect(job_application.reload.template).to be_falsey
      end
      it 'on create, template is not changed for other users' do
        expect(job_application.template).to be_truthy
        FactoryBot.create(:job_application, job: job, template: true)
        expect(job_application.reload.template).to be_truthy
      end
    end
  end

  context 'Relationships' do
    let!(:job_question) { FactoryBot.create(:job_question, job: job) }
    let!(:job_application_question) { FactoryBot.create(:job_application_question, job_question: job_question, job_application: job_application) }

    it 'belongs to a job' do
      expect(job_application.job).to eq(job)
    end

    it 'belongs to a freelancer_profile' do
      expect(job_application.freelancer_profile).to eq(freelancer_profile)
    end

    it 'has many job_application_questions with dependent: :destroy' do
      expect(job_application.job_application_questions).to include(job_application_question)
      expect(JobApplicationQuestion.exists?(job_application_question.id)).to be_truthy
      job_application.destroy
      expect(JobApplicationQuestion.exists?(job_application_question.id)).to be_falsey
    end

    it 'has many job_questions through job_application_questions without dependent destroy' do
      expect(job_application.job_questions).to include(job_question)
      job_application.destroy
      expect(JobQuestion.exists?(job_question.id)).to be_truthy
    end
  end

  context 'Scopes' do
    let(:freelancer_profile_dima) { FactoryBot.create(:freelancer_profile) }
    let(:freelancer_profile_nata) { FactoryBot.create(:freelancer_profile) }
    let(:freelancer_profile_erik) { FactoryBot.create(:freelancer_profile) }
    let!(:dima_user) { freelancer_profile_dima.user }
    let!(:nata_user) { freelancer_profile_nata.user }
    let!(:erik_user) { freelancer_profile_erik.user }
    let!(:employer_profile) { FactoryBot.create(:employer_profile) }
    let!(:job) { FactoryBot.create(:job, employer_profile: employer_profile) }
    let!(:declined_job_application) { FactoryBot.create(:job_application, freelancer_profile: freelancer_profile_dima, job: job, state: 'declined') }
    let!(:draft_job_application) { FactoryBot.create(:job_application, freelancer_profile: freelancer_profile_nata, job: job, state: 'draft') }
    let!(:applied_job_application) { FactoryBot.create(:job_application, freelancer_profile: freelancer_profile_erik, job: job, state: 'applied') }

    it '.not_rejected' do
      expect(JobApplication.draft_or_applied).to include(draft_job_application)
      expect(JobApplication.draft_or_applied).to include(applied_job_application)
      expect(JobApplication.draft_or_applied).to_not include(declined_job_application)
    end

    describe '.without_contracts' do
      let!(:job_for_dima) { FactoryBot.create(:job, employer_profile: employer_profile) }
      let!(:dima_job_application) { FactoryBot.create(:job_application, freelancer_profile: freelancer_profile_dima, job: job_for_dima) }
      let!(:nata_job_application) { FactoryBot.create(:job_application, freelancer_profile: freelancer_profile_nata, job: job_for_dima) }
      let!(:erik_job_application) { FactoryBot.create(:job_application, freelancer_profile: freelancer_profile_erik, job: job_for_dima) }
      let!(:contract) { FactoryBot.create(:contract, job: job_for_dima, freelancer_profile: freelancer_profile_dima, employer_profile: employer_profile) }

      it 'shows job_applications that do not have a contract' do
        expect(job_for_dima.job_applications.without_contracts).to include(nata_job_application)
        expect(job_for_dima.job_applications.without_contracts).to include(erik_job_application)
      end

      it 'hides job_applications that has a corresponding contract with the sane job and freelancer_profile' do
        expect(job_for_dima.job_applications.without_contracts).to_not include(dima_job_application)
      end
    end
  end
end
