# frozen_string_literal: true

class Employer::TalentController < ApplicationController
  include LoggedInRedirects
  before_action :authenticate_user!, :initial_check, :non_employer_redirect, :incomplete_employer_profile_redirect
  before_action :sectors_options_for_select, :skill_options_for_select, :software_options_for_select
  ITEMS_PER_PAGE = 5

  def index
    filters_list unless invalid_filtering_parameters?
    @pagy, @freelancer_profiles = pagy(freelancer_profiles_collection,
                                       page: page,
                                       items: ITEMS_PER_PAGE,
                                       overflow: :last_page)
    if freelancer_profiles_collection.empty?
    flash[:notice] =
      'No talent found that matches all of your search criteria.'
    end
    @current_user_interview_request_freelancer_ids = current_user.employer_profile
                                                                 .interview_requests
                                                                 .pluck(:freelancer_profile_id)
  end

  def interview_request
    @interview_request = current_user.employer_profile.interview_requests.create(interview_request_params)

    if @interview_request.valid?
      FreelancerMailer.interview_request(@interview_request).deliver_now

      flash[:notice] = '<i class="far fa-check-circle"></i> <strong> Success!</strong> '\
      'Your interview request has been sent to '\
      "<strong>#{@interview_request.freelancer_profile.full_name}</strong>. "\
      'We will send you a notification when it is accepted or declined.'
    else
      flash[:alert] = 'Something went wrong when trying to submit your interview request'
    end

    redirect_to employer_talent_index_path
  end

  private

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
end
