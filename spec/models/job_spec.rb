require 'rails_helper'

RSpec.describe Job, type: :model do
  let!(:job) { FactoryBot.create(:job) }

  it 'factory works' do
    expect(job).to be_valid
  end

  context 'Validations' do
    it { is_expected.to validate_presence_of(:user_id) }
    describe 'pay_ranges' do
      it 'can be nil' do
        job.pay_range_high = nil
        expect(job).to be_valid
        job.pay_range_low = nil
        expect(job).to be_valid
      end

      it 'if not nil it must be greater than pay_range_low' do
        job.pay_range_low = 100
        job.pay_range_high = 150
        expect(job).to be_valid
        job.pay_range_high = 50
        expect(job).to_not be_valid
      end

      it 'neither can be lower than 0' do
        job.pay_range_low = -10
        expect(job).to_not be_valid
        job.pay_range_low = nil
        expect(job).to be_valid
        job.pay_range_high = -50
        expect(job).to_not be_valid
      end
    end
  end

  context 'Relationships' do
    describe 'job_skills' do
      let!(:job_skill) { FactoryBot.create(:job_skill, job: job) }
      let!(:skill) { job_skill.skill }

      it 'has many with dependent destroy and skills through them' do
        expect(job.job_skills).to include(job_skill)
        expect(job.skills).to include(skill)
        job.destroy
        expect(JobSkill.exists?(job_skill.id)).to be_falsey
        expect(Skill.exists?(skill.id)).to be_truthy
      end
    end

    describe 'job_softwares' do
      let!(:job_software) { FactoryBot.create(:job_software, job: job) }
      let!(:software) { job_software.software }

      it 'has many with dependent destroy and softwares through them' do
        expect(job.job_softwares).to include(job_software)
        expect(job.softwares).to include(software)
        job.destroy
        expect(JobSoftware.exists?(job_software.id)).to be_falsey
        expect(Software.exists?(software.id)).to be_truthy
      end
    end

    describe 'job_sectors' do
      let!(:job_sector) { FactoryBot.create(:job_sector, job: job) }
      let!(:sector) { job_sector.sector }

      it 'has many with dependent destroy and sectors through them' do
        expect(job.job_sectors).to include(job_sector)
        expect(job.sectors).to include(sector)
        job.destroy
        expect(JobSector.exists?(job_sector.id)).to be_falsey
        expect(Sector.exists?(sector.id)).to be_truthy
      end
    end

    describe 'job_questions' do
      let!(:job_question) { FactoryBot.create(:job_question, job: job) }

      it 'has many job_questions with dependent destroy' do
        expect(job.job_questions).to include(job_question)
        job.destroy
        expect(JobQuestion.exists?(job_question.id)).to be_falsey
      end
    end

    describe 'job_applications' do
      let!(:job_application) { FactoryBot.create(:job_application, job: job) }
      it 'has many job_applications with dependent destroy' do
        expect(job.job_applications).to include(job_application)
        job.destroy
        expect(JobApplication.exists?(job_application.id)).to be_falsey
      end
    end
  end
end
