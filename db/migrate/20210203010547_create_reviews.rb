class CreateReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :reviews do |t|
      t.references :employer_profile, null: false, foreign_key: true
      t.references :freelancer_profile, null: false, foreign_key: true
      t.integer :rating
      t.text :comments

      t.timestamps
    end
  end
end
