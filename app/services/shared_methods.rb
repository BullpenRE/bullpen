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
  end
end
