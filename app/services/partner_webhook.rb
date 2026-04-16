# frozen_string_literal: true

class PartnerWebhook
  def self.call(...) = new(...).call

  def initialize(job:, partner:)
    @job = job
    @partner = partner
  end
  
  def call
    partner.deliver(payload)
  end
  
  private
  
  attr_reader :job, :partner
  
  def payload = { id: job.id, scheduled_at: job.scheduled_at, crew: job.crew&.name }
end
