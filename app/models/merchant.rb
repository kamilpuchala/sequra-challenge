class Merchant < ApplicationRecord
  VALID_DISBURSEMENT_FREQUENCIES = ["DAILY", "WEEKLY"]

  has_many :orders
  has_many :disbursements
  has_many :monthly_fees

  validates_presence_of :external_id, :reference, :email, :live_on, :disbursement_frequency,
    :minimum_monthly_fee
  validates_uniqueness_of :external_id, :reference
  validates :disbursement_frequency, inclusion: {in: VALID_DISBURSEMENT_FREQUENCIES}
end
