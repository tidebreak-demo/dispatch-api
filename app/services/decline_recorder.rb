# frozen_string_literal: true

class DeclineRecorder
  def self.call(...) = new(...).call

  def initialize(job:, reason:)
    @job = job
    @reason = reason
  end
  
  def call = job.dispatch_events.create!(kind: :declined, metadata: { reason: })
  
  private
  
  attr_reader :job, :reason
end
