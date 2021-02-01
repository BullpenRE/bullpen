class CreateJobApplicationQuestion < ActiveRecord::Migration[6.0]
  def change
    create_table :job_application_questions do |t|
      t.references :job_application, index: true, foreign_key: true
      t.references :job_question, index: true, foreign_key: true
      t.text :answer

      t.timestamps
    end
  end
end
