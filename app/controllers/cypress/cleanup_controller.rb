# frozen_string_literal: true

class Cypress::CleanupController < ActionController::Base
  def destroy
    return head(:bad_request) unless Rails.env.test?

    tables = ActiveRecord::Base.connection.tables
    tables.delete 'schema_migrations'
    tables.each do |t|
      ActiveRecord::Base.connection.execute("TRUNCATE #{t} CASCADE")
    end

    head :ok
  end
end
