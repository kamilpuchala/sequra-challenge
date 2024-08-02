class OrdersController < ApplicationController
  def create
    merchant = Merchant.find_by!(reference: order_params[:merchant_reference])
    order = Order.create!(prepared_order_params(merchant))

    render json: order, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: {errors: e.record.errors.full_messages}, status: :unprocessable_entity
  rescue ActiveRecord::RecordNotFound => e
    render json: {errors: e.message}, status: :not_found
  end

  private

  def order_params
    params.require(:order).permit(:amount, :date, :merchant_reference)
  end

  def prepared_order_params(merchant)
    order_params.merge(merchant_id: merchant.id).except(:merchant_reference)
  end
end
