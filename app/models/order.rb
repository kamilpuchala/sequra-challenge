class Order < ApplicationRecord
  FEE_TYPE = {
    FIRST_GROUP: 1.00,
    SECOND_GROUP: 0.95,
    THIRD_GROUP: 0.85
  }

  belongs_to :merchant

  validates_presence_of :amount, :date, :fee_percentage
  validates :fee_percentage, numericality: {greater_than_or_equal_to: 0.85, less_than_or_equal_to: 1}
  before_save :set_fee_percentage

  private

  def set_fee_percentage
    self.fee_percentage = fee_percents
  end

  def fee_percents
    return FEE_TYPE[:FIRST_GROUP] if amount < 50
    return FEE_TYPE[:SECOND_GROUP] if amount < 300
    FEE_TYPE[:THIRD_GROUP]
  end
end
