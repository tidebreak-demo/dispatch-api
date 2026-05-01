# frozen_string_literal: true

class Assignment < ApplicationRecord
  belongs_to :job
  belongs_to :crew

  validate :no_overlap

  private

  def no_overlap
    return unless crew&.jobs&.for_window(job.window)&.where&.not(id: job_id)&.exists?

    errors.add(:base, "crew is already booked for this window")
  end
end
