# frozen_string_literal: true

require "rails_helper"

RSpec.describe CertificationBoardFilter do
  subject(:result) { described_class.call(job:, crew:) }

  let(:job) { create(:job, :scheduled) }
  let(:crew) { create(:crew, :available) }

  it "assigns the crew" do
    expect(result).to eq(:assigned)
    expect(job.reload.crew).to eq(crew)
  end

  it "records the assignment event" do
    expect { result }.to change { job.events.where(kind: :assigned).count }.by(1)
  end

  context "when the crew is not eligible" do
    let(:crew) { create(:crew, :ineligible) }

    it "refuses with :unavailable" do
      expect(result).to eq(:unavailable)
      expect(job.reload.crew).to be_nil
    end
  end

  context "when the job is taken between the check and the write" do
    before { allow(job).to receive(:assign).and_raise(ActiveRecord::RecordInvalid.new(job)) }

    it "reports the conflict rather than raising" do
      expect(result).to eq(:conflict)
    end
  end
end
