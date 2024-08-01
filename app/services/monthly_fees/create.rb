module MonthlyFees
  class Create
    attr_reader :merchant, :month, :year
    
    def initialize(merchant:, month:, year:)
      @merchant = merchant
      @month = month
      @year = year
    end
    
    def call
      MonthlyFee.create!(
        merchant: merchant,
        year: year,
        month: month,
        charged_fee: charged_fee,
        fee_to_charge: fee_to_charge
      )
    end
    
    private
    
    
    def charged_fee
      @charged_fee ||= month_disbursements.sum(&:total_fees)
    end
    
    def fee_to_charge
      return 0 if charged_fee >= merchant.minimum_monthly_fee
      
      merchant.minimum_monthly_fee - charged_fee
    end
    def month_disbursements
      range = Date.new(year, month).all_month
      
      merchant.disbursements.where(reference_date: range)
    end
  
  end
end
