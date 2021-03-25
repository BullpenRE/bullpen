require 'rails_helper'

describe FreelancersHelper, type: :helper do
  describe '#freelancer_ba_link' do
    let!(:current_user) { FactoryBot.create(:user, :freelancer) }
    before do
      allow(helper).to receive(:current_user).and_return(current_user)
    end

    let(:expected_output) do
      "https://connect.stripe.com/express/oauth/authorize?redirect_uri=#{freelancer_stripe_connect_url}" \
      "&client_id=#{ENV['STRIPE_CLIENT_ID']}&stripe_user%5Bemail%5D=#{current_user.email}" \
      "&stripe_user%5Bfirst_name%5D=#{current_user.first_name}" \
      "&stripe_user%5Blast_name%5D=#{current_user.last_name}&stripe_user%5Bphone_number%5D=#{current_user.phone_number}" \
      "&stripe_user%5Bcountry%5D=US"
    end

    it 'returns the correct url' do
      expect(helper.freelancer_ba_link).to eq(expected_output)
    end
  end
end
