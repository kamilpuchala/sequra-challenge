class Merchant < ApplicationRecord
  VALID_DISBURSEMENT_FREQUENCIES = ["DAILY", "WEEKLY"]

  has_many :orders

  validates_presence_of :external_id, :reference, :email, :live_on, :disbursement_frequency,
    :minimum_monthly_fee, :weekday
  validates_uniqueness_of :external_id, :reference
  validates :disbursement_frequency, inclusion: {in: VALID_DISBURSEMENT_FREQUENCIES}
  validates :weekday, inclusion: {in: 0..6}
end
