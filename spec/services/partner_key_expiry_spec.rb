# frozen_string_literal: true

require "rails_helper"

RSpec.describe PartnerKeyExpiry do
  subject(:expired) { described_class.call }

  it "expires a key unused for longer than the idle window" do
    key = create(:partner_api_key, last_used_at: 91.days.ago)

    expect(expired).to eq([key])
    expect(key.reload.expired_at).to be_present
  end

  it "keeps a key used inside the window" do
    create(:partner_api_key, last_used_at: 10.days.ago)

    expect(expired).to be_empty
  end

  it "expires a key that was never used once it is older than the window" do
    key = create(:partner_api_key, last_used_at: nil, created_at: 120.days.ago)

    expect(expired).to eq([key])
  end
end
