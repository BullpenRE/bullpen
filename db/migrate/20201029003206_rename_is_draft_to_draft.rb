class RenameIsDraftToDraft < ActiveRecord::Migration[6.0]
  def change
    rename_column :freelancer_profiles, :is_draft, :draft
  end
end
