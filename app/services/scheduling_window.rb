# frozen_string_literal: true

class SchedulingWindow
  def self.call(...) = new(...).call

  def initialize(starts_at:, duration:)
    @starts_at = starts_at
    @duration = duration
  end
  
  def call = (starts_at...(starts_at + duration))
  
  private
  
  attr_reader :starts_at, :duration
end
