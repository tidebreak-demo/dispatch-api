# frozen_string_literal: true

module Api
  class CrewsController < ApplicationController
    def index
      render json: Crew.available_for(window_param)
    end

    private

    def window_param = SchedulingWindow.call(starts_at: Time.zone.parse(params[:from]), duration: 8.hours)
  end
end
