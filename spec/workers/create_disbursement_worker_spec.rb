RSpec.describe CreateDisbursementWorker, type: :worker do
  before { travel_to Time.zone.local(2024, 7, 1) }

  after { travel_back }

  subject { described_class.new.perform }

  context "when creating disbursements" do
    context "when merchant is DAILY merchant" do
      let!(:merchant) { create(:merchant, live_on: 1.month.ago, disbursement_frequency: "DAILY") }
      it "call Disbursements::Create" do
        disbursement_service = instance_double(Disbursements::Create, call: true)
        allow(Disbursements::Create).to receive(:new).with(merchant: merchant, date: Date.yesterday).and_return(disbursement_service)

        subject

        expect(disbursement_service).to have_received(:call)
      end
    end

    context "when merchant is WEEKLY merchant" do
      context "when weekday is the same as merchant live on wday" do
        let!(:merchant) { create(:merchant, live_on: Date.today - 8.days, disbursement_frequency: "WEEKLY") }

        it "call Disbursements::Create" do
          disbursement_service = instance_double(Disbursements::Create, call: true)
          allow(Disbursements::Create).to receive(:new).with(merchant: merchant, date: Date.yesterday).and_return(disbursement_service)

          subject

          expect(disbursement_service).to have_received(:call)
        end
      end

      context "when weekday isn't the same as merchant live on wday" do
        let!(:merchant) { create(:merchant, live_on: Date.today - 3.days, disbursement_frequency: "WEEKLY") }

        it "call Disbursements::Create" do
          disbursement_service = instance_double(Disbursements::Create, call: true)
          allow(Disbursements::Create).to receive(:new).with(merchant: merchant, date: Date.yesterday).and_return(disbursement_service)

          subject

          expect(disbursement_service).to_not have_received(:call)
        end
      end
    end
  end
end
