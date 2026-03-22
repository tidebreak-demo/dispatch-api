# frozen_string_literal: true

class CrewAssigner
  def self.call(...) = new(...).call

  def initialize(job:)
    @job = job
  end
  
  def call
    candidate = Crew.available_for(job.window).min_by { |crew| crew.distance_to(job.site) }
    return :no_crew_available unless candidate
  
    job.assign(candidate)
  end
  
  private
  
  attr_reader :job
end
