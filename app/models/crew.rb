# frozen_string_literal: true

class Crew < ApplicationRecord
  has_many :jobs, dependent: :nullify
  has_many :certifications, dependent: :destroy

  def available?(window)
    jobs.for_window(window).none?
  end
end
