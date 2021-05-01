class SharedMethods
  class << self
    def production_or_admin?
      Rails.env.production? || Rails.env.admin?
    end

    def verify_dump_name(passed_name)
      passed_name.present? && File.file?(passed_name) ? passed_name : nil
    end

    def most_recent_dump_file
      file = Dir["./*.dump"].max_by { |f| File.mtime(f) }
      file.present? ? file[2..-1] : nil
    end

    def aa_and_table_exists?(table)
      return false unless defined?(ActiveAdmin)

      ActiveRecord::Base.connection
    rescue ActiveRecord::NoDatabaseError
      false
    else
      ApplicationRecord.connection.data_source_exists?(table)
    end
  end
end
