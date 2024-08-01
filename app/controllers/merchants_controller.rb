class MerchantsController < ApplicationController
  def create
    merchant = Merchant.create!(merchant_params)
    render json: merchant, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: {errors: e.record.errors.full_messages}, status: :unprocessable_entity
  end

  private

  def merchant_params
    params.require(:merchant).permit(:external_id, :reference, :email, :live_on, :disbursement_frequency,
      :minimum_monthly_fee)
  end
end
