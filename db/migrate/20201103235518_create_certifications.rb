class CreateCertifications < ActiveRecord::Migration[6.0]
  def change
    create_table :certifications do |t|
      t.string :description
      t.boolean :disable
      t.boolean :custom

      t.timestamps
    end
  end
end
