require "rails_helper"

RSpec.describe Merchant, type: :model do
  subject { build(:merchant) }

  it { should have_many(:orders) }

  describe "validations" do
    it { should validate_presence_of(:external_id) }
    it { should validate_presence_of(:reference) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:live_on) }
    it { should validate_presence_of(:disbursement_frequency) }
    it { should validate_presence_of(:minimum_monthly_fee) }
    it { should validate_presence_of(:weekday) }

    it { should validate_uniqueness_of(:external_id) }
    it { should validate_uniqueness_of(:reference) }

    it { should validate_inclusion_of(:disbursement_frequency).in_array(Merchant::VALID_DISBURSEMENT_FREQUENCIES) }
    it { should validate_inclusion_of(:weekday).in_range(0..6) }
  end
end
