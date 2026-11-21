# frozen_string_literal: true

# Retires partner API keys nobody has used for a while, so a partner that left months ago does not
# keep a working key. Returns the keys it expired so the caller can tell each partner's contact.
class PartnerKeyExpiry
  IDLE_DAYS = 90

  def self.call(...) = new(...).call

  def initialize(scope: PartnerApiKey.active, clock: Time)
    @scope = scope
    @clock = clock
  end

  def call
    idle_keys.each { |key| expire(key) }
  end

  private

  attr_reader :scope, :clock

  def idle_keys
    cutoff = clock.current - (IDLE_DAYS * 86_400)
    scope.where("last_used_at < ? OR (last_used_at IS NULL AND created_at < ?)", cutoff, cutoff).to_a
  end

  def expire(key)
    key.update!(expired_at: clock.current, expiry_reason: :idle)
    Rails.logger.info("expired idle partner key #{key.id} for partner #{key.partner_id}")
    key
  end
end
