# frozen_string_literal: true

class CertificationGuard
  def self.call(...) = new(...).call

  def initialize(job:, crew:)
    @job = job
    @crew = crew
  end

  def call
    return :unavailable unless crew.available?(job.window)

    job.assign(crew)
  end

  private

  attr_reader :job, :crew
end
