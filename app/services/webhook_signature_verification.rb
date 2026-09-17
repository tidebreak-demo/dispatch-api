# frozen_string_literal: true

# Decides whether a crew may take a job, and records why when it may not. The caller treats
# every symbol other than :assigned as a refusal it can show the dispatcher.
class WebhookSignatureVerification
  MAX_WEEKLY_HOURS = 48

  def self.call(...) = new(...).call

  def initialize(job:, crew:, clock: Time)
    @job = job
    @crew = crew
    @clock = clock
  end

  def call
    return :unavailable unless eligible?

    assign
  end

  private

  attr_reader :job, :crew, :clock

  def eligible?
      return false unless crew.available?(job.window)
      return false unless crew.covers?(job.site)

      true
    end

  def assign
    job.transaction do
      job.assign(crew)
      job.events.create!(kind: :assigned, actor: crew, at: clock.current)
    end

    :assigned
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.warn("assignment failed for job #{job.id}: #{e.message}")
    :conflict
  end
end
