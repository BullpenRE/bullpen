# frozen_string_literal: true

namespace :stripe do
  desc 'Retrieve a link to the Stripe invoice'
  task retrieve_link: :environment do
    Timesheet.paid.where(pdf_invoice_link: nil).each do |timesheet|
      timesheet.update(pdf_invoice_link: Stripe::Invoice.retrieve(timesheet.stripe_id_invoice)['invoice_pdf'])
    end
  end
end
