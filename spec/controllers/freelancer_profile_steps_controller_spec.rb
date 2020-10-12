require 'rails_helper'

describe FreelancerProfileStepsController, type: :controller do
  let(:user)  { FactoryBot.create(:user) }
  let!(:freelancer_profile) { FactoryBot.create(:freelancer_profile, user: user) }
  let!(:freelancer_profile_experience) { create(:freelancer_profile_experience, freelancer_profile: freelancer_profile) }

  before(:each) { sign_in :user, user }

  describe 'GET :freelancer_profile_steps/work_education_experience' do
    specify 'request' do
      get :show, params: { id: :work_education_experience }, xhr: true
      expect(response).to have_http_status(:ok)
      expect(response).to render_template("freelancer_profile_steps/work_education_experience")
    end
  end

  describe 'GET :freelancer_profile_steps/skills_page' do
    specify 'request' do
      get :show, params: { id: :skills_page }, xhr: true
      expect(response).to have_http_status(:ok)
      expect(response).to render_template("freelancer_profile_steps/skills_page")
    end
  end

  describe 'GET :freelancer_profile_steps/professional_history' do
    specify 'request' do
      get :show, params: { id: :professional_history }, xhr: true
      expect(response).to have_http_status(:ok)
      expect(response).to render_template("freelancer_profile_steps/professional_history")
    end
  end
end
