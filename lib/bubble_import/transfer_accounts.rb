# frozen_string_literal: true

# How to use:
# > transfer = BubbleImport::TransferAccounts.new
# > transfer.user_service.retrieve_all
# > transfer.freelancer_service.retrieve_all
# > transfer.create_new_users!
# > transfer.create_new_freelancer_profiles!

module BubbleImport
  class TransferAccounts
    attr_accessor :user_service, :freelancer_service, :company_service

    def initialize
      @user_service = BubbleExtractData.new('User')
      @freelancer_service = BubbleExtractData.new('Freelancer')
      @company_service = BubbleExtractData.new('Company')
    end

    def create_new_users!
      @user_service.retrieve_all unless @user_service.retrieved?
      @user_service.process(lookup_key: 'email')
      return false if missing_user_account_emails.empty?

      created_users = 0
      missing_user_account_emails.each do |email|
        next unless @user_service.lookup[email].present?

        user = User.create(new_user_param(@user_service.lookup[email]))
        @user_service.results.find { |result| result['_id'] == @user_service.lookup[email]['_id'] }['user_id'] = user.id
        created_users += 1
      end

      puts "################## Created #{created_users} new users ##################"
    end

    def create_new_freelancer_profiles!
      @freelancer_service.retrieve_all unless @freelancer_service.retrieved?
      @freelancer_service.process(lookup_key: '_id')
      @user_service.retrieve_all unless @user_service.retrieved?
      insert_ids_into_services(User, @user_service) unless @user_service.results.last['user_id'].present?
      @user_service.process(lookup_key: '_id')
      users_ids_in_freelancer_profile = FreelancerProfile.pluck(:user_id)

      created_freelancer_profiles = 0
      @freelancer_service.keys.each do |freelancer_bubble_id|
        bubble_freelancer = @freelancer_service.lookup[freelancer_bubble_id]
        bubble_user = @user_service.lookup[bubble_freelancer['User']]
        next unless bubble_freelancer && bubble_user

        next if users_ids_in_freelancer_profile.include?(bubble_user['user_id'])

        freelancer_profile = FreelancerProfile.create(new_freelancer_profile_param(bubble_freelancer, bubble_user['user_id']))
        next unless freelancer_profile.present?

        @freelancer_service.results.find { |result| result['_id'] == freelancer_bubble_id }['freelancer_profile_id'] = freelancer_profile.id
        created_freelancer_profiles += 1
      end

      puts "################## Created #{created_freelancer_profiles} new freelancer_profiles  ##################"
    end

    private

    def insert_ids_into_services(model, service)
      return false unless service&.retrieved?

      id_lookup = model.where.not(id_bubble: nil).pluck(:id_bubble, :id).to_h
      service.results.each do |result|
        result["#{model.to_s.tableize.singularize}_id"] = id_lookup[result['_id']] if id_lookup[result['_id']]
      end

      true
    end

    def missing_user_account_emails
      @missing_user_account_emails ||= @user_service.keys - User.pluck(:email)
    end

    def new_user_param(bubble_user)
      {
        email: bubble_user['email'],
        password: Devise.friendly_token.first(6),
        first_name: bubble_user['First Name'],
        last_name: bubble_user['Last Name'],
        id_bubble: bubble_user['_id'],
        role: bubble_user['is_freelancer?'] ? 'freelancer' : 'employer',
        # disable: bubble_user['Is Active?'] == false,
        confirmed_at: Time.current,
        location: bubble_user['address'],
        longitude: bubble_user['lat'],
        latitude: bubble_user['lng'],
        skip_geocoding: bubble_user['lat'].present? && bubble_user['lng'].present?,
        phone_number: bubble_user['Phone Number']
      }
    end

    def new_freelancer_profile_param(bubble_freelancer, user_id)
      {
        user_id: user_id,
        professional_title: bubble_freelancer['Job Title'],
        professional_years_experience: bubble_freelancer['Years of Experience'],
        professional_summary: bubble_freelancer['Professional Summary'],
        curation: freelancer_curation(bubble_freelancer),
        draft: bubble_freelancer['Is Draft?'] == true,
        desired_hourly_rate: bubble_freelancer['Desired hourly rate'],
        new_jobs_alert: bubble_freelancer['Is New Job Notifications?'],
        searchable: (bubble_freelancer['Is Accepted?'] && !bubble_freelancer['Is Draft?']),
        payout_percentage: 70,
        stripe_id_account: bubble_freelancer['Stripe Seller ID'],
        id_bubble: bubble_freelancer['_id']
      }
    end

    def freelancer_curation(bubble_freelancer)
      return 'declined' if bubble_freelancer['Is Declined?']
      return 'accepted' if bubble_freelancer['Is Accepted?']

      'pending'
    end
  end
end
