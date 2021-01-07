# frozen_string_literal: true

module WorkCertification
  def certification_save
    return unless params[:freelancer_certification].present?

    freelancer_certification_options
  end

  private

  def freelancer_certification_options
    if freelancer_certification.present? && params[:commit] == 'Delete'
      freelancer_certification.destroy
    elsif freelancer_certification.present?
      return freelancer_custom_certificate_update if check_edit_custom_certificate_field?
      freelancer_certification.update(checked_freelancer_certification_params)
    else
      freelancer_certification_create
    end
  end

  def check_edit_custom_certificate_field?
    return if freelancer_certification&.certification&.custom.nil?

    freelancer_certification.certification.custom !=
      (params[:freelancer_certification][:custom] == '1')
  end

  def freelancer_custom_certificate_update
    freelancer_certification.destroy
    freelancer_certification_create
  end

  def freelancer_certification_create
    @freelancer_profile.freelancer_certifications.create(checked_freelancer_certification_params)
  end

  def checked_freelancer_certification_params
    if params[:freelancer_certification][:description].blank?
      freelancer_certification_params
    else
      return freelancer_certification_params if check_edit_custom_certificate_field?

      params.require(:freelancer_certification)
            .permit(:id, :certification_id, :description, :earned_year, :earned_month)
            .merge(certification_id: Certification.custom_id)
    end
  end

  def freelancer_certification_params
    params.require(:freelancer_certification)
      .permit(:id, :certification_id, :earned_year, :earned_month)
      .merge(description: Certification.find_by(id: params[:freelancer_certification][:certification_id]).description)
  end

  def freelancer_certification
    @freelancer_certification ||=
      @freelancer_profile&.freelancer_certifications&.find_by(id: params[:freelancer_certification][:id])
  end
end
