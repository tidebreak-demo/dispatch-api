# frozen_string_literal: true

class Certification < ApplicationRecord
  belongs_to :crew

  scope :valid_on, ->(date) { where(expires_on: date..) }
end
