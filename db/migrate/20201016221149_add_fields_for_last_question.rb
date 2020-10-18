class AddFieldsForLastQuestion < ActiveRecord::Migration[6.0]
  def change
    add_column :employer_profiles, :motivation_one_time, :boolean
    add_column :employer_profiles, :motivation_ongoing_support, :boolean
    add_column :employer_profiles, :motivation_backfill, :boolean
    add_column :employer_profiles, :motivation_augment, :boolean
    add_column :employer_profiles, :motivation_other, :boolean
  end
end
