module EmployersPresenter
  class FreelancersFilter
    def initialize(sector_ids: [], real_estate_skill_ids: [], software_ids: [])
      @sector_ids = sector_ids
      @real_estate_skill_ids = real_estate_skill_ids
      @software_ids = software_ids

      scrub_ids!
    end

    def valid?
      @sector_ids.any? || @real_estate_skill_ids.any? || @software_ids.any?
    end

    def freelancer_profile_ids
      return [] unless valid?
      matches = {}
      (sector_fp_ids + skills_fp_ids + software_fp_ids).each do |fp_id|
        matches[fp_id] = matches[fp_id].to_i.succ
      end

      matches.reject {|_fp_id, count| count < total_matches_needed}.keys
    end

    private

    def scrub_ids!
      @sector_ids = Sector.enabled.where(id: @sector_ids).pluck(:id) if @sector_ids.any?
      @real_estate_skill_ids = RealEstateSkill.enabled.where(id: @real_estate_skill_ids).pluck(:id) if @real_estate_skill_ids.any?
      @software_ids = Software.enabled.where(id: @software_ids).pluck(:id) if @software_ids.any?
    end

    def sector_fp_ids
      @sector_fp_ids ||= FreelancerSector.where(sector_id: @sector_ids).pluck(:freelancer_profile_id)
    end

    def skills_fp_ids
      @skills_fp_ids ||= FreelancerRealEstateSkill.where(real_estate_skill_id: @real_estate_skill_ids).pluck(:freelancer_profile_id)
    end

    def software_fp_ids
      @software_fp_ids ||= FreelancerSoftware.where(software_id: @software_ids).pluck(:freelancer_profile_id)
    end

    def total_matches_needed
      @total_matches_needed ||= (@sector_ids.count + @real_estate_skill_ids.count + @software_ids.count)
    end
  end
end