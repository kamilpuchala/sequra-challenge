class Disbursement < ApplicationRecord
  belongs_to :merchant
  has_many :orders, dependent: :nullify

  validates :reference, :total_amount, :total_fees, :reference_date, presence: true
  validates :reference, uniqueness: {case_sensitive: true}
end
