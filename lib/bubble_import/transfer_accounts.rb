# frozen_string_literal: true

# How to use:
# > transfer = BubbleImport::TransferAccounts.new
# > transfer.fetch_all_users
# > transfer.fetch_all_freelancer_profiles
# > transfer.create_new_bubble_users!

module BubbleImport
  class TransferAccounts
    attr_accessor :user_service, :freelancer_service

    def initialize
      @user_service = BubbleExtractData.new('User')
      @freelancer_service = BubbleExtractData.new('Freelancer')
    end

    def fetch_all_users
      @user_service.retrieve_all
    end

    def fetch_all_freelancer_profiles
      @freelancer_service.retrieve_all
    end

    def missing_user_account_emails
      @missing_user_account_emails ||= @user_service.keys - User.pluck(:email)
    end

    def create_new_bubble_users!
      @user_service.process(lookup_key: 'email')
      @freelancer_service.process(lookup_key: 'User')
      return false if missing_user_account_emails.empty?

      bulk_create = []

      missing_user_account_emails.each do |email|
        bubble_user = @user_service.lookup[email]
        next unless bubble_user.present?

        bubble_freelancer = @freelancer_service.lookup[bubble_user['_id']]
        next unless bubble_freelancer.present?

        new_user = User.create(new_user_param(email, bubble_user, bubble_freelancer))
        bulk_create << new_user
      end

      puts "Created #{bulk_create.length} new users"
    end

    private

    def new_user_param(email, bubble_user, bubble_freelancer)
      {
        email: email,
        password: Devise.friendly_token.first(6),
        first_name: bubble_user['First Name'],
        last_name: bubble_user['Last Name'],
        id_bubble: bubble_user['_id'],
        role: bubble_user['is_freelancer?'] ? 'freelancer' : 'employer',
        # disable: bubble_user['Is Active?'] == false,
        confirmed_at: Time.current,
        location: bubble_freelancer['address'],
        longitude: bubble_freelancer['lat'],
        latitude: bubble_freelancer['lng'],
        skip_geocoding: bubble_freelancer['lat'].present? && bubble_freelancer['lng'].present?,
        phone_number: bubble_freelancer['Phone Number']
      }
    end
  end
end
