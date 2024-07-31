require "rails_helper"

RSpec.describe Order, type: :model do
  subject { build(:order) }

  it { should belong_to(:merchant) }

  describe "validations" do
    it { should validate_presence_of(:amount) }
    it { should validate_presence_of(:date) }
    it { should validate_presence_of(:fee_percentage) }

    it "is valid with a fee_percentage between 0 and 100" do
      expect(build(:order, fee_percentage: 1.00)).to be_valid
      expect(build(:order, fee_percentage: 0.85)).to be_valid
    end

    it "is not valid with a fee_percentage less than 0.85" do
      expect(build(:order, fee_percentage: 0.84)).not_to be_valid
    end

    it "is not valid with a fee_percentage greater than 1" do
      expect(build(:order, fee_percentage: 1.01)).not_to be_valid
    end
  end
end
