# frozen_string_literal: true

# How to use:
# > retrieve_users = BubbleImport::RetrieveUsers.new
# > retrieve_users.process

module BubbleImport
  class RetrieveUsers
    attr_accessor :service, :bulk_create

    def initialize
      @service = BubbleExtractData.new('User')
      @errors = []
    end

    def process
      puts 'Starting retrieval and processing'
      return false unless service.retrieve_all && service.process(lookup_key: 'email')

      populate_existing_users_bubble_ids!
      create_new_bubble_users!
    end

    private

    def populate_existing_users_bubble_ids!
      total_users = User.where(id_bubble: nil, email: service.lookup.keys)
      updated_users = 0

      total_users.find_each do |user|
        matching_bubble_user = service.lookup[user.email]
        next unless matching_bubble_user

        user.update(id_bubble: matching_bubble_user['_id'])
        updated_users += 1
      end

      puts "#{updated_users} out of #{total_users.size} existing users had their bubble id updated."
    end

    def create_new_bubble_users!
      bulk_create = []
      missing_user_account_emails.each do |email|
        bubble_user = service.lookup[email]
        new_user = User.create(new_user_param(email, bubble_user))
        bulk_create << new_user
      end

      puts "Assembled #{bulk_create.length} new users to create in 'bulk_create'"
      @bulk_create = bulk_create

      true
    end

    def missing_user_account_emails
      @missing_user_account_emails ||= missing_user_account_emails!
    end

    def missing_user_account_emails!
      service.keys - User.pluck(:email)
    end

    def new_user_param(email, bubble_user)
      {
        email: email,
        password: Devise.friendly_token.first(6),
        first_name: bubble_user['First Name'],
        last_name: bubble_user['Last Name'],
        id_bubble: bubble_user['_id'],
        role: bubble_user['is_freelancer?'] ? 'freelancer' : 'employer',
        # disable: bubble_user['Is Active?'] == false,
        confirmed_at: Time.current
      }
    end
  end
end
