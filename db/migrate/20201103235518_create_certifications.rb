class CreateCertifications < ActiveRecord::Migration[6.0]
  def change
    create_table :certifications do |t|
      t.string :description
      t.boolean :disable, default: false
      t.boolean :custom, default: :false

      t.timestamps
    end
  end
end
