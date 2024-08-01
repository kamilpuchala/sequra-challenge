RSpec.describe MonthlyFees::Create, type: :service do
  let(:merchant) { create(:merchant, minimum_monthly_fee: 50.0) }
  let(:month) { 7 }
  let(:year) { 2024 }
  let(:service) { described_class.new(merchant: merchant, month: month, year: year) }
  
  describe 'call' do
    context 'when total disbursements fees exceed minimum monthly fee' do
      let!(:disbursement_1) do
        create(:disbursement,
               merchant: merchant,
               total_fees: 20.0,
               reference: "#{merchant.reference}_#{Date.new(2024, 7, 1)}",
               reference_date:  Date.new(2024,7,1)
        )
      end
      let!(:disbursement_2) do
        create(:disbursement,
               merchant: merchant,
               total_fees: 30.0,
               reference: "#{merchant.reference}_#{Date.new(2024, 7, 2)}",
               reference_date:  Date.new(2024,7,2))
      end
      let!(:disbursement_3) do
        create(:disbursement,
               merchant: merchant,
               total_fees: 30.0,
               reference: "#{merchant.reference}_#{Date.new(2024, 6, 2)}",
               reference_date:  Date.new(2024,6,2)
        )
      end
      let!(:disbursement_4) do
        create(:disbursement,
               merchant: merchant2,
               total_fees: 30.0,
               reference: "#{merchant2.reference}_#{Date.new(2024, 7, 2)}",
               reference_date:  Date.new(2024,7,2)
        )
      end
      let(:merchant2) { create(:merchant) }
      
      it 'creates a monthly fee with zero fee to charge' do
        expect { service.call }.to change { MonthlyFee.count }.by(1)
        monthly_fee = MonthlyFee.last
        expect(monthly_fee.charged_fee.to_f).to eq(50.0)
        expect(monthly_fee.fee_to_charge.to_f).to eq(0.0)
      end
    end
    
    context 'when total disbursements fees are less than minimum monthly fee' do
      let!(:disbursement_1) do
        create(:disbursement,
               merchant: merchant,
               total_fees: 20.0,
               reference: "#{merchant.reference}_#{Date.new(2024, 7, 1)}",
               reference_date:  Date.new(2024,7,1)
        )
      end
      let!(:disbursement_2) do
        create(:disbursement,
               merchant: merchant,
               total_fees: 10.0,
               reference: "#{merchant.reference}_#{Date.new(2024, 7, 2)}",
               reference_date:  Date.new(2024,7,2)
        )
      end
      let!(:disbursement_3) do
        create(:disbursement,
               merchant: merchant2,
               total_fees: 30.0,
               reference: "#{merchant2.reference}_#{Date.new(2024, 7, 2)}",
               reference_date:  Date.new(2024,7,2)
        )
      end
      let(:merchant2) { create(:merchant) }
      
      it 'creates a monthly fee with the correct fee to charge' do
        expect { service.call }.to change { MonthlyFee.count }.by(1)
        monthly_fee = MonthlyFee.last
        expect(monthly_fee.charged_fee.to_f).to eq(30.0)
        expect(monthly_fee.fee_to_charge.to_f).to eq(20.0)
      end
    end
    
    context 'when there are no disbursements in the month' do
      it 'creates a monthly fee with the full minimum fee to charge' do
        expect { service.call }.to change { MonthlyFee.count }.by(1)
        monthly_fee = MonthlyFee.last
        expect(monthly_fee.charged_fee.to_f).to eq(0.0)
        expect(monthly_fee.fee_to_charge.to_f).to eq(50.0)
      end
    end
  end
end
