ActiveAdmin.register FreelancerProfile do
  menu label: 'Freelancers'

  includes :user, :freelancer_asset_classes, :freelancer_real_estate_skills, :freelancer_profile_educations, :freelancer_profile_experiences

  filter :user_email, as: :string, label: 'User Email'

  permit_params :professional_summary, :professional_title, :professional_years_experience

  index do
    column :user
    column 'Title', :professional_title
    column 'Years Experience', :professional_years_experience

    actions
  end

  show title: 'Freelancer Profile' do |freelancer_profile|
    attributes_table do
      row 'Email' do
        freelancer_profile.user.email
      end
      row :created_at
      row :updated_at
      row :professional_title
      row :professional_years_experience
      row :professional_summary
      row 'Asset Classes' do
        freelancer_profile.freelancer_asset_classes.map{|f_a_c| f_a_c.asset_class.description }.to_sentence
      end
      row 'Real Estate Skills' do
        freelancer_profile.freelancer_real_estate_skills.map{|f_r_e_s| f_r_e_s.real_estate_skill.description }.to_sentence
      end
      row 'Education' do
        freelancer_profile.freelancer_profile_educations.map{|f_e| "#{'<i>(current)</i> ' if f_e.currently_studying}#{f_e.graduation_year} #{f_e.degree} in #{f_e.course_of_study} at #{f_e.institution}" }.join('<br>').html_safe
      end
    end
  end

  form do |f|
    f.inputs "#{f.object.user.email} Freelancer Profile" do
      f.input :professional_title
      f.input :professional_years_experience
      f.input :professional_summary
      f.actions
    end
  end

end
