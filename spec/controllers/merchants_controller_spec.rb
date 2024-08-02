# spec/controllers/merchants_controller_spec.rb
require "rails_helper"

RSpec.describe MerchantsController, type: :controller do
  describe "POST #create" do
    let(:valid_attributes) do
      {
        merchant: {
          external_id: "12345",
          reference: "ref123",
          email: "merchant@example.com",
          live_on: "2024-08-01",
          disbursement_frequency: "WEEKLY",
          minimum_monthly_fee: 100.0
        }
      }
    end

    let(:invalid_attributes) do
      {
        merchant: {
          external_id: nil,
          reference: nil,
          email: "merchant@example.com",
          live_on: "2024-08-01",
          disbursement_frequency: "weekly",
          minimum_monthly_fee: 100.0
        }
      }
    end

    context "with valid params" do
      it "creates a new Merchant" do
        expect {
          post :create, params: valid_attributes
        }.to change(Merchant, :count).by(1)
      end

      it "returns a success response (status code 201)" do
        post :create, params: valid_attributes
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid params" do
      it "does not create a new Merchant" do
        expect {
          post :create, params: invalid_attributes
        }.to change(Merchant, :count).by(0)
      end

      it "returns an unprocessable entity response (status code 422)" do
        post :create, params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
