require "rails_helper"

RSpec.describe Disbursements::Create, type: :service do
  subject { described_class.new(merchant: merchant_1, date: date) }

  describe "call" do
    context "when merchant has DAILY calculation" do
      let(:merchant_1) do
        create(:merchant, reference: "company_1", disbursement_frequency: "DAILY", live_on: Date.new(2024, 7, 1))
      end
      let(:merchant_2) do
        create(:merchant, reference: "company_2", disbursement_frequency: "DAILY", live_on: Date.new(2024, 7, 1))
      end

      let!(:order_1) { create(:order, merchant: merchant_1, date: Date.new(2024, 7, 31), amount: 100) }
      let!(:order_2) { create(:order, merchant: merchant_1, date: Date.new(2024, 7, 31), amount: 310) }
      let!(:order_3) { create(:order, merchant: merchant_1, date: Date.new(2024, 8, 1), amount: 100) }
      let!(:order_4) { create(:order, merchant: merchant_2, date: Date.new(2024, 7, 31), amount: 100) }

      let(:date) { Date.new(2024, 7, 31) }

      it "creates a disbursement with the correct total amount and fees" do
        expect { subject.call }.to change { Disbursement.count }.by(1)
        disbursement = Disbursement.last
        expect(disbursement.total_amount.to_f).to eq(410.0)
        expect(disbursement.total_fees.to_f).to eq(3.59)
        expect(disbursement.reference).to eq("company_1_2024-07-31")
      end
    end

    context "when merchant has WEEKLY calculation" do
      let(:merchant_1) do
        create(:merchant, reference: "company_1", disbursement_frequency: "WEEKLY", live_on: live_on)
      end
      let(:live_on) { Date.new(2024, 7, 1) }

      context "when calculation is running for incorrect weekday" do
        let(:date) { live_on + 1.day }

        it { expect { subject.call }.to raise_error(CantCreateDisbursementForMerchant) }
      end

      context "when calculation is running in a correct weekday" do
        let(:date) { live_on + 7.days }

        context "when merchant doesn't have orders in previous week" do
          let!(:order_1) { create(:order, merchant: merchant_1, date: date + 1.day, amount: 100) }
          let!(:order_2) { create(:order, merchant: merchant_1, date: date - 8.days, amount: 100) }

          it "creates a disbursement with the correct total amount and fees" do
            expect { subject.call }.to change { Disbursement.count }.by(1)
            disbursement = Disbursement.last
            expect(disbursement.total_amount.to_f).to eq(0.0)
            expect(disbursement.total_fees.to_f).to eq(0.0)
            expect(disbursement.reference).to eq("company_1_2024-07-02..2024-07-08")
          end
        end

        context "when merchant has orders in previous week" do
          let(:merchant_2) do
            create(:merchant, reference: "company_2", disbursement_frequency: "DAILY", live_on: live_on)
          end
          let!(:order_1) { create(:order, merchant: merchant_1, date: date + 1.day, amount: 100) }
          let!(:order_2) { create(:order, merchant: merchant_1, date: date - 8.days, amount: 100) }
          let!(:order_3) { create(:order, merchant: merchant_1, date: date - 1.day, amount: 100) }
          let!(:order_4) { create(:order, merchant: merchant_1, date: date - 2.days, amount: 310) }
          let!(:order_5) { create(:order, merchant: merchant_2, date: date - 1.day, amount: 100) }

          it "creates a disbursement with the correct total amount and fees" do
            expect { subject.call }.to change { Disbursement.count }.by(1)
            disbursement = Disbursement.last
            expect(disbursement.total_amount.to_f).to eq(410.0)
            expect(disbursement.total_fees.to_f).to eq(3.59)
            expect(disbursement.reference).to eq("company_1_2024-07-02..2024-07-08")
          end
        end
      end
    end
  end
end
