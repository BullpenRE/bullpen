module EmployersPresenter
  class FreelancersFilter
    def initialize(sector_ids: [], real_estate_skill_ids: [], software_ids: [])
      @sector_ids = sector_ids
      @real_estate_skill_ids = real_estate_skill_ids
      @software_ids = software_ids

      scrub_ids!
    end

    def valid?
      return false if @sector_ids.empty? && @real_estate_skill_ids.empty? && @software_ids.empty?

      true
    end

    private

    def scrub_ids!
      @sector_ids = Sector.enabled.where(id: @sector_ids).pluck(:id) if @sector_ids.any?
      @real_estate_skill_ids = RealEstateSkill.enabled.where(id: @real_estate_skill_ids).pluck(:id) if @real_estate_skill_ids.any?
      @software_ids = Software.enabled.where(id: @software_ids).pluck(:id) if @software_ids.any?
    end
  end
end