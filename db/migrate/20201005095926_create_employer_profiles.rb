class CreateEmployerProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :employer_profiles do |t|
      t.string :company_name
      t.string :company_website
      t.string :role_in_company
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
