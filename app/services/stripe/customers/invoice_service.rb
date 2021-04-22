# frozen_string_literal: true

module Stripe
  module Customers
    class InvoiceService
      def initialize(timesheet)
        @timesheet = timesheet
        @contract = @timesheet.contract
        @employer_profile = @contract.employer_profile
        @user = @employer_profile.user
        @credits = @timesheet.credits
      end

      # rubocop:disable Metrics/MethodLength
      def call
        add_billing_items
        add_credit_items if @credits.present?
        invoice = create_invoice

        if invoice['id'].present?
          @timesheet.update(stripe_id_invoice: invoice['id'],
                            invoice_number: invoice['number'],
                            employer_charged_on: Time.current,
                            pdf_invoice_link: invoice['invoice_pdf'])
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

      def add_billing_item(billing_item)
        Stripe::InvoiceItem.create({
                                     customer: @employer_profile.stripe_id_customer,
                                     amount: (billing_item.multiplier * @contract.pay_rate * 100).to_i,
                                     currency: 'usd',
                                     description: billing_item.description
                                   })
      end

      def add_credit_item(credit_item)
        Stripe::InvoiceItem.create({
                                     customer: @employer_profile.stripe_id_customer,
                                     amount: (credit_item.amount * -100).to_i,
                                     currency: 'usd',
                                     description: credit_item.description
                                   })
      end

      def add_billing_items
        @timesheet.billings.pending.each do |pending_billing|
          add_billing_item(pending_billing)
        end
      end

      def create_invoice
        Stripe::Invoice.create({
                                 customer: @employer_profile.stripe_id_customer,
                                 auto_advance: true, # auto-finalize this draft after ~1 hour
                                 default_source: @contract.payment_account.id_stripe
                               })
      end

      def add_credit_items
        return if @timesheet.credits.sum(&:amount) > @timesheet.employer_total_charge

        @timesheet.credits.each do |credit|
          add_credit_item(credit)
        end
      end
    end
  end
end
