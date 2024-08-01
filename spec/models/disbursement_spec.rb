require "rails_helper"

RSpec.describe Disbursement, type: :model do
  subject { build(:disbursement) }

  it { should belong_to(:merchant) }
  it { should have_many(:orders) }

  describe "validations" do
    it { should validate_presence_of(:reference) }
    it { should validate_presence_of(:total_amount) }
    it { should validate_presence_of(:total_fees) }
    it { should validate_presence_of(:reference_date) }

    it { should validate_uniqueness_of(:reference) }
  end
end
