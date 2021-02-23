# frozen_string_literal: true

module CreateContract
  def close_job_if_offer_is_made
    job.update(state: 'closed') if close_job_checked?
  end

  def create_make_an_offer_flash_notice
    flash[:notice] = "Your <strong>#{@contract.title}</strong> offer has been sent to
                      <strong>#{@contract.freelancer_profile.full_name}</strong>.
                      We'll send a notification when it's accepted."
  end

  def update_make_an_offer_flash_notice
    flash[:notice] = "#{@contract.state.capitalize} contract <b>#{@contract.title}</b>
                     for <b>#{@contract.freelancer_profile.full_name}</b> has been updated."
  end

  def make_an_offer_params_without_job
    params.require(:make_an_offer)
          .permit(:job_description, :title, :freelancer_profile_id, :contract_type, :pay_rate)
  end

  def update_make_an_offer_params
    params.require(:make_an_offer)
          .permit(:job_description, :title, :pay_rate, :contract_type)
  end

  def make_an_offer_params
    params.require(:make_an_offer)
          .permit(:job_id, :job_description, :title, :freelancer_profile_id, :contract_type, :pay_rate)
  end

  def job
    @job ||= current_user.employer_profile.jobs.find_by(id: params[:id])
  end

  private

  def close_job_checked?
    params[:make_an_offer][:state] == '1'
  end
end
