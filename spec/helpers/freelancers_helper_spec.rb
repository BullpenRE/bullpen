require 'rails_helper'

describe FreelancersHelper, type: :helper do
  describe '#stripe_button_link' do
    let(:user) { FactoryBot.create(:user, :freelancer) }
    before do
      allow(helper).to receive(:current_user).and_return(user)
    end

    let(:expected_output) do
      "https://connect.stripe.com/express/oauth/authorize?redirect_uri=#{stripe_connect_url}" \
      "&client_id=#{ENV['STRIPE_CLIENT_ID']}&stripe_user%5Bemail%5D=#{user.email}" \
      "&stripe_user%5Bbusiness_type%5D=individual&stripe_user%5Bfirst_name%5D=#{user.first_name}" \
      "&stripe_user%5Blast_name%5D=#{user.last_name}&stripe_user%5Bphone_number%5D=#{user.phone_number}" \
      "&stripe_user%5Bcountry%5D=US"
    end

    it 'returns the correct url' do
      expect(helper.stripe_button_link).to eq(expected_output)
    end
  end
end