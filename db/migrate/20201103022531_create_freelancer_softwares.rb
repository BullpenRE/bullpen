class CreateFreelancerSoftwares < ActiveRecord::Migration[6.0]
  def change
    create_table :freelancer_softwares do |t|
      t.references :freelancer_profile, null: false, foreign_key: true
      t.references :software, null: false, foreign_key: true
      t.boolean :license, default: true

      t.timestamps
    end
  end
end
