# frozen_string_literal: true

module WorkEducationExperience
  def freelancer_profile_education_save
    return unless params[:freelancer_profile_education].present?

    freelancer_education_options
  end

  def work_experience_save
    return unless params[:freelancer_profile_experience].present?

    if work_profile_experience.present? && params[:commit] == 'Delete'
      work_profile_experience.destroy
    elsif work_profile_experience.present?
      unless work_profile_experience.update(checked_profile_experience_params)
        flash.now[:alert] = work_profile_experience.errors.full_messages.join(', ')
      end
    else
      object = FreelancerProfileExperience.create(checked_profile_experience_params)
      flash.now[:alert] = object.errors.full_messages.join(', ') unless object.errors.count.zero?
    end
  end

  private

  def freelancer_education_options
    if education_profile_experience.present? && params[:commit] == 'Delete'
      education_profile_experience.destroy
    elsif education_profile_experience.present?
      education_profile_experience.update(checked_profile_education_params)
    else
      FreelancerProfileEducation.create(checked_profile_education_params)
    end
  end

  def profile_experience_params
    params.require(:freelancer_profile_experience)
          .permit(:id, :job_title, :company, :location, :description,
                  :start_month, :start_year, :end_month, :end_year, :current_job)
  end

  def profile_education_params
    params.require(:freelancer_profile_education)
          .permit(:id, :institution, :degree, :course_of_study, :graduation_year, :currently_studying, :description)
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

  def current_job?
    params[:freelancer_profile_experience][:current_job] == '1'
  end

  def work_profile_experience
    @work_profile_experience ||=
      @freelancer_profile&.freelancer_profile_experiences&.find_by(id: params[:freelancer_profile_experience][:id])
  end

  def education_profile_experience
    @education_profile_experience ||=
      @freelancer_profile&.freelancer_profile_educations&.find_by(id: params[:freelancer_profile_education][:id])
  end
end
