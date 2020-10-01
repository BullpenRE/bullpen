require 'rails_helper'

RSpec.describe "Bootstraptests", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/bootstraptest/index"
      expect(response).to have_http_status(:success)
    end
  end

end
