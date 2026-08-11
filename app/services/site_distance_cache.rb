# frozen_string_literal: true

class SiteDistanceCache
  def self.call(...) = new(...).call

  def initialize(site:)
    @site = site
  end
  
  def call = Rails.cache.fetch([:site_distance, site.id], expires_in: 5.minutes) { site.distances }
  
  private
  
  attr_reader :site
end
