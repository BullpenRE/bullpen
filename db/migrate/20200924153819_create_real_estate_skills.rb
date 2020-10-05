class CreateRealEstateSkills < ActiveRecord::Migration[6.0]
  def change
    create_table :real_estate_skills do |t|
      t.string :description, null: false
      t.boolean :disable, default: false
      t.timestamps
    end
  end
end
