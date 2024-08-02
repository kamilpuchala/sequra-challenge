require "rails_helper"

RSpec.describe Order, type: :model do
  subject { build(:order) }

  it { should belong_to(:merchant) }

  describe "validations" do
    it { should validate_presence_of(:amount) }
    it { should validate_presence_of(:date) }

    it "automatically sets the correct fee_percentage based on the amount" do
      order1 = build(:order, amount: 30, fee_percentage: 0.84)
      order2 = build(:order, amount: 150, fee_percentage: 1.84)
      order3 = build(:order, amount: 400, fee_percentage: 2.84)

      order1.valid?
      order2.valid?
      order3.valid?

      expect(order1.fee_percentage).to eq(1.00)
      expect(order2.fee_percentage).to eq(0.95)
      expect(order3.fee_percentage).to eq(0.85)
    end
  end
end
