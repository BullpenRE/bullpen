class CreateJobQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :job_questions do |t|
      t.references :job, null: false, foreign_key: true
      t.string :description

      t.timestamps
    end
  end
end
