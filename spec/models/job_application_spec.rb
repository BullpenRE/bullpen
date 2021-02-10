require 'rails_helper'

RSpec.describe JobApplication, type: :model do
  let(:job) { FactoryBot.create(:job) }
  let!(:job_application) { FactoryBot.create(:job_application, job: job, template: true) }
  let!(:user) { job_application.user }
  let(:job_application_with_attachments) { FactoryBot.create(:job_application, :with_attachments) }

  it 'factory works' do
    expect(job_application).to be_valid
    expect(job_application_with_attachments).to be_valid
    expect(job_application_with_attachments.work_samples.attached?).to be_truthy
    expect(job_application_with_attachments.cover_letter).to_not be_blank
  end

  context 'Validations' do
    it 'the combination of job_id and user_id is unique' do
      duplicate = FactoryBot.create(:job_application)
      duplicate.job_id = job_application.job_id
      expect(duplicate).to be_valid
      duplicate.user_id = job_application.user_id
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
      it 'on create, it is set to false for all other job_applications for the same user' do
        expect(job_application.template).to be_truthy
        FactoryBot.create(:job_application, user: user, template: true)
        expect(job_application.reload.template).to be_falsey
      end
      it 'on update, it is set to false for all other job_applications' do
        new_application_same_user = FactoryBot.create(:job_application, user: user, template: false)
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

    it 'belongs to a user' do
      expect(job_application.user).to eq(user)
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
    let(:freelancer_user_dima)  { FactoryBot.create(:user, :freelancer) }
    let(:freelancer_user_nata)  { FactoryBot.create(:user, :freelancer) }
    let(:freelancer_user_erik)  { FactoryBot.create(:user, :freelancer) }
    let(:employer_user)  { FactoryBot.create(:user, :employer) }
    let(:job)  { FactoryBot.create(:job, user: employer_user ) }
    let!(:declined_job_application) { FactoryBot.create(:job_application, user: freelancer_user_dima, job: job, state: 'declined') }
    let!(:draft_job_application) { FactoryBot.create(:job_application, user: freelancer_user_nata, job: job, state: 'draft') }
    let!(:applied_job_application) { FactoryBot.create(:job_application, user: freelancer_user_erik, job: job, state: 'applied') }

    it '.not_rejected' do
      expect(JobApplication.draft_or_applied).to include(draft_job_application)
      expect(JobApplication.draft_or_applied).to include(applied_job_application)
      expect(JobApplication.draft_or_applied).to_not include(declined_job_application)
    end

    describe 'without contracts' do
      let(:dima)  { FactoryBot.create(:user, :freelancer) }
      let(:nata)  { FactoryBot.create(:user, :freelancer) }
      let(:erik)  { FactoryBot.create(:user, :freelancer) }
      let!(:employer_profile) { FactoryBot.create(:employer_profile) }
      let!(:dima_job_application) { FactoryBot.create(:job_application, user: dima, job: job) }
      let!(:nata_job_application) { FactoryBot.create(:job_application, user: nata, job: job) }
      let!(:erik_job_application) { FactoryBot.create(:job_application, user: erik, job: job) }
      let!(:job_1) { FactoryBot.create(:job, user: employer_profile.user) }
      let(:freelancer_profile_dima) { FactoryBot.create(:freelancer_profile, :complete, user: dima) }
      let!(:contract) { FactoryBot.create(:contract, :with_job, job: job_1, freelancer_profile: freelancer_profile_dima) }

      it '.without_contracts_for(job)' do
        expect(JobApplication.without_contracts_for(job_1)).to_not include(dima_job_application)
        expect(JobApplication.without_contracts_for(job_1)).to include(nata_job_application)
        expect(JobApplication.without_contracts_for(job_1)).to include(erik_job_application)
      end
    end
  end
end
