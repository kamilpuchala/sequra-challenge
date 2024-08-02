module Disbursements
  class Create
    attr_reader :merchant, :date
    def initialize(merchant:, date:)
      @merchant = merchant
      @date = date
    end

    def call
      if merchant.disbursement_frequency == "WEEKLY" && merchant.live_on.wday != date.wday
        raise CantCreateDisbursementForMerchant, "Can't create disbursement for #{merchant.reference} in date #{date}"
      end

      ::ActiveRecord::Base.transaction do
        disbursement = Disbursement.create!(
          merchant: merchant,
          total_amount: total_amount,
          total_fees: total_fees,
          reference: reference,
          reference_date: date
        )

        orders.update_all(disbursement_id: disbursement.id)
      end
    end

    private

    def orders
      @orders ||= merchant.orders.where(date: date_range, disbursement_id: nil)
    end

    def date_range
      (merchant.disbursement_frequency == "DAILY") ? date : date - 6.days..date
    end

    def total_amount
      orders.sum(&:amount).round(2)
    end

    def total_fees
      orders.sum { |order| order.amount * (order.fee_percentage / 100) }.round(2)
    end

    def reference
      "#{merchant.reference}_#{date_range}"
    end
  end
end

class CantCreateDisbursementForMerchant < StandardError; end
