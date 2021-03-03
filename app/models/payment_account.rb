# frozen_string_literal: true

class PaymentAccount < ApplicationRecord
  belongs_to :employer_profile

  enum stripe_object: { card: 0, bank_account: 1 }

  after_save :set_other_defaults_false, if: :default?


  private

  def set_other_defaults_false
    PaymentAccount.where(employer_profile_id: employer_profile_id).where.not(id: id).update_all(default: false)
  end
end
