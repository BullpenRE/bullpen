require 'rails_helper'

describe Test::SeedsController do
  describe '/seed_posts' do
    it 'seeds posts' do
      FactoryBot.create(:user)

      expect {
        post :seed_posts, params: { count: 1 }
      }.to change { User.count }.by 1
    end
  end
end
