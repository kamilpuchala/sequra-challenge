# spec/controllers/orders_controller_spec.rb
require "rails_helper"

RSpec.describe OrdersController, type: :controller do
  describe "POST #create" do
    let!(:merchant) { create(:merchant, reference: "ref123") }
    let(:valid_attributes) do
      {
        order: {
          amount: 100.0,
          date: "2024-08-01",
          merchant_reference: "ref123"
        }
      }
    end

    let(:invalid_attributes) do
      {
        order: {
          amount: nil,
          date: "2024-08-01",
          merchant_reference: "ref123"
        }
      }
    end

    let(:nonexistent_merchant_attributes) do
      {
        order: {
          amount: 100.0,
          date: "2024-08-01",
          merchant_reference: "nonexistent"
        }
      }
    end

    context "with valid params" do
      it "creates a new Order" do
        expect {
          post :create, params: valid_attributes, as: :json
        }.to change(Order, :count).by(1)
      end

      it "returns a created status" do
        post :create, params: valid_attributes, as: :json
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid params" do
      it "does not create a new Order" do
        expect {
          post :create, params: invalid_attributes, as: :json
        }.to change(Order, :count).by(0)
      end

      it "returns an unprocessable entity status" do
        post :create, params: invalid_attributes, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns errors in the response" do
        post :create, params: invalid_attributes, as: :json
        json_response = JSON.parse(response.body)
        expect(json_response["errors"]).to include("Amount can't be blank")
      end
    end

    context "with nonexistent merchant reference" do
      it "does not create a new Order" do
        expect {
          post :create, params: nonexistent_merchant_attributes, as: :json
        }.to change(Order, :count).by(0)
      end

      it "returns a not found status" do
        post :create, params: nonexistent_merchant_attributes, as: :json
        expect(response).to have_http_status(:not_found)
      end

      it "returns an error message in the response" do
        post :create, params: nonexistent_merchant_attributes, as: :json
        json_response = JSON.parse(response.body)
        expect(json_response["errors"]).to include("Couldn't find Merchant")
      end
    end
  end
end
