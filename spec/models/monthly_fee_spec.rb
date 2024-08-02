require "rails_helper"

RSpec.describe MonthlyFee, type: :model do
  subject { build(:monthly_fee) }

  it { should belong_to(:merchant) }

  describe "validations" do
    it { should validate_presence_of(:month) }
    it { should validate_presence_of(:year) }
    it { should validate_presence_of(:charged_fee) }
    it { should validate_presence_of(:fee_to_charge) }

    it { should validate_inclusion_of(:year).in_array(MonthlyFee::VALID_YEARS) }
    it { should validate_inclusion_of(:month).in_array(MonthlyFee::VALID_MONTHS) }

    describe "uniquenes in scope of merchant, year and month" do
      let(:merchant) { create(:merchant) }
      let!(:monthly_fee) { create(:monthly_fee, merchant: merchant, month: 8, year: 2024) }
      it "is not valid with duplicate month and year for the same merchant" do
        duplicate_monthly_fee = MonthlyFee.new(merchant: merchant, month: 8, year: 2024)
        expect(duplicate_monthly_fee).not_to be_valid
        expect(duplicate_monthly_fee.errors[:merchant_id]).to include("has already been taken")
      end

      it "is valid with the same month and year for different merchants" do
        different_merchant = create(:merchant)
        new_monthly_fee = MonthlyFee.new(merchant: different_merchant, month: 8, year: 2025)
        expect(new_monthly_fee).to be_valid
      end

      it "is valid with different month and year for the same merchant" do
        new_monthly_fee = MonthlyFee.new(merchant: merchant, month: 9, year: 2024)
        expect(new_monthly_fee).to be_valid
      end
    end
  end
end
