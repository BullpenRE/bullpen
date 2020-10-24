class ChangeAssetClassToSector < ActiveRecord::Migration[6.0]
  def change
    drop_table :sectors if ActiveRecord::Base.connection.data_source_exists? 'sectors'
    rename_table :asset_classes, :sectors
    rename_table :freelancer_asset_classes, :freelancer_sectors
    rename_column :freelancer_sectors, :asset_class_id, :sector_id
  end
end
