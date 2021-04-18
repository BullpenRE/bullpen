# frozen_string_literal: true

module Stripe
  module Customers
    class InvoiceService
      def initialize(timesheet)
        @timesheet = timesheet
        @contract = @timesheet.contract
        @employer_profile = @contract.employer_profile
        @user = @employer_profile.user
      end

      # rubocop:disable Metrics/MethodLength
      def call
        prepare_invoice
        invoice = create_invoice

        if invoice['id'].present?
          @timesheet.update(stripe_id_invoice: invoice['id'],
                            invoice_number: invoice['number'],
                            employer_charged_date: Time.current)
        end
        true
      rescue StandardError => e
        ::Rails.logger.info(
          "Error in Stripe::Customers::InvoiceService impacting user id: #{@user.id}, "\
          "timetheet ID: #{@timesheet.id}, "\
          "Contract: #{@contract.title}, "\
          "error details: #{e}"
        )
        { error: e }
      end
      # rubocop:enable Metrics/MethodLength

      private

      def add_invoice_item(billing_item)
        Stripe::InvoiceItem.create({
                                     customer: @employer_profile.stripe_id_customer,
                                     amount: billing_item.multiplier * @contract.pay_rate * 100,
                                     currency: 'usd',
                                     description: billing_item.description
                                   })
      end

      def prepare_invoice
        @timesheet.billings.pending.each do |pending_billing|
          add_invoice_item(pending_billing)
        end
      end

      def create_invoice
        Stripe::Invoice.create({
                                 customer: @employer_profile.stripe_id_customer,
                                 auto_advance: true, # auto-finalize this draft after ~1 hour
                                 default_source: @contract.payment_account.id_stripe
                               })
      end
    end
  end
end
