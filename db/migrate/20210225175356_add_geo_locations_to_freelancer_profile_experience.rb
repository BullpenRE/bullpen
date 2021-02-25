class AddGeoLocationsToFreelancerProfileExperience < ActiveRecord::Migration[6.1]
  def change
    add_column :freelancer_profile_experiences, :latitude, :float
    add_column :freelancer_profile_experiences, :longitude, :float
    add_index :freelancer_profile_experiences, %i[latitude longitude]
  end
end
