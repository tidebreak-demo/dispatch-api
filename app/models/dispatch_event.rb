# frozen_string_literal: true

class DispatchEvent < ApplicationRecord
  belongs_to :job

  enum :kind, { dispatched: 0, accepted: 1, declined: 2, completed: 3 }
end
