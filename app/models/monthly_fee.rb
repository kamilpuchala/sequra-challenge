class MonthlyFee < ApplicationRecord
  belongs_to :merchant
  
  VALID_YEARS = (2020..2100).to_a
  VALID_MONTHS = (1..12).to_a
  
  validates_presence_of :year, :month, :charged_fee, :fee_to_charge
  validates :month, inclusion: {in: VALID_MONTHS}
  validates :year, inclusion: {in: VALID_YEARS}
  validates :merchant_id, uniqueness: { scope: [:month, :year] }
end
