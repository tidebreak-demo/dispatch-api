# frozen_string_literal: true

class PartnerDeliveryJob < ApplicationJob
  queue_as :default
  retry_on Net::ReadTimeout, attempts: 2

  def perform(job, partner)
    PartnerWebhook.call(job:, partner:)
  end
end
