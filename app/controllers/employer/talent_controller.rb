# frozen_string_literal: true

class Employer::TalentController < ApplicationController
  include RequestReferer

  before_action :authenticate_user!, :initial_check, :non_employer_redirect, :incomplete_employer_profile_redirect
  before_action :sectors_options_for_select, :skill_options_for_select, :software_options_for_select,
                :confirm_employer_account_flash_notice
  ITEMS_PER_PAGE = 5

  def index
    filters_list unless invalid_filtering_parameters?
    @pagy, @freelancer_profiles = pagy(freelancer_profiles_collection.user_enabled,
                                       page: page,
                                       items: ITEMS_PER_PAGE,
                                       overflow: :last_page)
    if freelancer_profiles_collection.empty?
      flash[:notice] = 'No talent found that matches all of your search criteria.'
    end

    mixpanel_talent_tracker('Find Talent')
  end

  def interview_request
    if interview_id.present?
      @interview_request = current_user.employer_profile.interview_requests.find_by(id: interview_id)
      @interview_request.update(message: params[:interview_request][:message])
      flash[:notice] = 'Your interview request message was successfully modified for '\
                       "<b>#{@interview_request.freelancer_profile.full_name}</b>. "\
                       'No new emails were sent but they will see the new text on their dashboard.'
      @interview_request.update(state: 'pending') if @interview_request.withdrawn? || @interview_request.declined?

      mixpanel_talent_tracker('Update Interview Request')
      redirect_to employer_interviews_path
    else
      @interview_request = current_user.employer_profile.interview_requests.create(interview_request_params)
      email_interview_request

      mixpanel_talent_tracker('Add Interview Request')
      redirect_to employer_talent_index_path(referer_page_params)
    end
  end

  private

  def email_interview_request
    if @interview_request.valid?
      FreelancerMailer.interview_request(@interview_request).deliver_later

      flash[:notice] = '<i class="far fa-check-circle"></i> <strong> Success!</strong> '\
      'Your interview request has been sent to '\
      "<strong>#{@interview_request.freelancer_profile.full_name}</strong>. "\
      'We will send you a notification when it is accepted or declined.'
    else
      flash[:alert] = 'Something went wrong when trying to submit your interview request'
    end
  end

  def interview_id
    params[:interview_request][:interview_id]
  end

  def interview_request_params
    params.require(:interview_request).permit(:freelancer_profile_id, :state, :message)
  end

  def sectors_options_for_select
    @sectors_options_for_select ||= Sector.enabled.pluck(:description, :id)
  end

  def skill_options_for_select
    @skill_options_for_select ||= RealEstateSkill.enabled.pluck(:description, :id)
  end

  def software_options_for_select
    @software_options_for_select ||= Software.enabled.pluck(:description, :id)
  end

  def all_freelancer_profiles
    FreelancerProfile.accepted
                     .searchable
                     .includes(:real_estate_skills,
                               :sectors,
                               :softwares,
                               :freelancer_certifications,
                               :freelancer_profile_educations,
                               :freelancer_profile_experiences).where(draft: false)
  end

  def freelancer_profiles_collection
    return all_freelancer_profiles if invalid_filtering_parameters?

    filter = EmployerFreelancersHelper::Filter.new(
      sector_ids: sector_ids,
      real_estate_skill_ids: real_estate_skill_ids,
      software_ids: software_ids
    )

    all_freelancer_profiles.where(id: filter.freelancer_profile_ids)
  end

  def filtering_params
    params.require(:search).permit(sector_ids: [], real_estate_skill_ids: [], software_ids: [])
  end

  def sector_ids
    filtering_params[:sector_ids].reject(&:empty?).map(&:to_i)
  end

  def real_estate_skill_ids
    filtering_params[:real_estate_skill_ids].reject(&:empty?).map(&:to_i)
  end

  def software_ids
    filtering_params[:software_ids].reject(&:empty?).map(&:to_i)
  end

  def invalid_filtering_parameters?
    params[:search].blank? || (sector_ids.blank? && real_estate_skill_ids.blank? && software_ids.blank?)
  end

  def filters_list
    @filters_list ||= (Sector.where(id: sector_ids).map(&:description) +
                      RealEstateSkill.where(id: real_estate_skill_ids).map(&:description) +
                      Software.where(id: software_ids).map(&:description)).sort
  end

  def page
    return params[:page] || 1 unless session[:request_interview]
    return delete_session unless freelancer_profiles_collection.pluck(:slug).include?(session[:request_interview])

    index = freelancer_profiles_collection.map(&:slug).index(session[:request_interview])
    @freelancer_profile_id = freelancer_profiles_collection[index].id
    session.delete(:request_interview)

    ((index + 1) / ITEMS_PER_PAGE.to_f).ceil
  end

  def delete_session
    session.delete(:request_interview)

    params[:page] || 1
  end

  def referer_page_params
    params_hash = referer_query_params.transform_values(&:first)
    params_hash.select { |key, _| key.start_with?('page') }
  end

  def mixpanel_talent_tracker(action)
    MixpanelWorker.perform_async(current_user.id, action, { 'user': current_user.email })
  end
end
