require 'rails_helper'

RSpec.describe "Currencies", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/currencies/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /history" do
    it "returns http success" do
      get "/currencies/history"
      expect(response).to have_http_status(:success)
    end
  end

end
