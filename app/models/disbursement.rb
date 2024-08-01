class Disbursement < ApplicationRecord
  belongs_to :merchant
  has_many :orders

  validates :reference, :total_amount, :total_fees, presence: true
  validates :reference, uniqueness: {case_sensitive: true}
end
