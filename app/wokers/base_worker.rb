# frozen_string_literal: true

class BaseWorker
  include Sidekiq::Worker

  sidekiq_options queue: "kiotviet_#{Rails.env}_default"
end
