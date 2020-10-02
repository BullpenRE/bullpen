class CreateFreelancerAssetClasses < ActiveRecord::Migration[6.0]
  def change
    create_table :freelancer_asset_classes do |t|
      t.references :freelancers, foreign_key: true
      t.references :asset_classes, foreign_key: true
      t.timestamps
    end
  end
end
