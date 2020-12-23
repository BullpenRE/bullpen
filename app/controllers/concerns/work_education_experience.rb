# frozen_string_literal: true

module WorkEducationExperience
  def freelancer_profile_education_save
    return unless params[:freelancer_profile_education].present?

    if education_profile_experience.present? && params[:commit] == 'Delete'
      education_profile_experience.destroy
    elsif education_profile_experience.present?
      education_profile_experience.update(checked_profile_education_params)
    else
      FreelancerProfileEducation.create(checked_profile_education_params)
    end
  end

  def work_experience_save
    return unless params[:freelancer_profile_experience].present?

    if work_profile_experience.present? && params[:commit] == 'Delete'
      work_profile_experience.destroy
    elsif work_profile_experience.present?
      work_profile_experience.update(checked_profile_experience_params)
    else
      FreelancerProfileExperience.create(checked_profile_experience_params)
    end
  rescue
    false
  end

  def certification_save
    return unless params[:freelancer_certification].present?

    if freelancer_certification.present? && params[:commit] == 'Delete'
      freelancer_certification.destroy
    elsif freelancer_certification.present?
      freelancer_certification.update(checked_freelancer_certification_params)
    else
      @freelancer_profile.freelancer_certifications.create(checked_freelancer_certification_params)
    end
  end

  private

  def profile_experience_params
    params.require(:freelancer_profile_experience)
          .permit(:job_title, :company, :location, :description,
                  :start_month, :start_year, :end_month, :end_year, :current_job)
  end

  def profile_education_params
    params.require(:freelancer_profile_education)
          .permit(:institution, :degree, :course_of_study, :graduation_year, :currently_studying, :description)
  end

  def checked_profile_education_params
    education_params = if currently_studying?
                         profile_education_params.reject { |param| param == 'graduation_year' }
                       else
                         profile_education_params
                       end

    education_params.merge(freelancer_profile_id: @freelancer_profile.id)
  end

  def currently_studying?
    params[:freelancer_profile_education][:currently_studying] == true
  end

  def checked_profile_experience_params
    experience_params = if current_job?
                          profile_experience_params.reject { |param| param == 'end_month' || param == 'end_year' }
                        else
                          profile_experience_params
                        end

    experience_params.merge(freelancer_profile_id: @freelancer_profile.id)
  end

  def checked_freelancer_certification_params
    if params[:freelancer_certification][:description].blank?
      params.require(:freelancer_certification)
        .permit(:certification_id, :earned_year, :earned_month)
        .merge(description: Certification.find_by(id: params[:freelancer_certification][:certification_id]).description)
    else
      params.require(:freelancer_certification)
        .permit(:description, :earned_year, :earned_month)
        .merge(certification_id: Certification.custom_id)
    end
  end

  def current_job?
    params[:freelancer_profile_experience][:current_job] == true
  end

  def work_profile_experience
    @freelancer_profile&.freelancer_profile_experiences&.find_by(id: params[:freelancer_profile_experience][:id])
  end

  def education_profile_experience
    @freelancer_profile&.freelancer_profile_educations&.find_by(id: params[:freelancer_profile_education][:id])
  end

  def freelancer_certification
    @freelancer_profile&.freelancer_certifications&.find_by(id: params[:freelancer_certification][:id])
  end
end
