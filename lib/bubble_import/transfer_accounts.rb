# frozen_string_literal: true

# How to use:
# > transfer = BubbleImport::TransferAccounts.new
# > transfer.user_service.retrieve_all
# > transfer.freelancer_service.retrieve_all
# > transfer.company_service.retrieve_all
# > transfer.create_new_bubble_users!

module BubbleImport
  class TransferAccounts
    attr_accessor :user_service, :freelancer_service, :company_service

    def initialize
      @user_service = BubbleExtractData.new('User')
      @freelancer_service = BubbleExtractData.new('Freelancer')
      @company_service = BubbleExtractData.new('Company')
    end

    def create_new_bubble_users!
      @user_service.retrieve_all unless @user_service.retrieved?
      @user_service.process(lookup_key: 'email')
      return false if missing_user_account_emails.empty?

      created_users = {}
      missing_user_account_emails.each do |email|
        next unless @user_service.lookup[email].present?

        user = User.create(new_user_param(@user_service.lookup[email]))
        created_users[email] = user.id
      end
      update_user_service_results_with_ids(created_users)

      puts "################## Created #{created_users.size} new users ##################"
    end

    private

    def update_user_service_results_with_ids(new_user_ids)
      @user_service.results.each do |result|
        user_id = new_user_ids[result['authentication']['email']['email']]
        next unless user_id

        result['user_id'] = user_id
      end
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
  end
end
