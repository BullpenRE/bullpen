# frozen_string_literal: true

class CreditService
  def initialize(timesheet, applied_to)
    @timesheet = timesheet
    @applied_to = applied_to
  end

  def process
    Credit.create(credit_params)
    user_profile.update(credit_balance: user_profile.credit_balance - amount_of_credit)
  end

  private

  def credit_params
    {
      timesheet_id: @timesheet.id,
      amount: amount_of_credit,
      applied_to: @applied_to
    }
  end

  def user_profile
    @user_profile ||= user_profile!
  end

  def user_profile!
    return @timesheet.contract.freelancer_profile if @applied_to == 'freelancer'

    @timesheet.contract.employer_profile
  end

  def amount_of_credit
    return user_profile.credit_balance if @applied_to == 'freelancer'
    return @timesheet.total_usd if @timesheet.total_usd < user_profile.credit_balance

    user_profile.credit_balance
  end
end
