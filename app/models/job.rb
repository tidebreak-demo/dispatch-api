# frozen_string_literal: true

class Job < ApplicationRecord
  belongs_to :site
  belongs_to :crew, optional: true

  enum :status, { unassigned: 0, assigned: 1, in_progress: 2, completed: 3 }

  scope :for_window, ->(window) { where(scheduled_at: window) }
end
