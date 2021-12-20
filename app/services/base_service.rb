# frozen_string_literal: true

class BaseService
  attr_reader :errors, :result, :metadata

  def initialize(*)
    @errors = []
    @result = nil
    @metadata = nil
  end

  def self.call(*args)
    service = new(*args)
    service.call
    service
  end

  def success?
    errors.blank?
  end
  alias valid? success?

  def errors_add(message)
    @errors ||= []

    if message.is_a?(Array)
      @errors += message
    elsif message.is_a?(ActiveModel::Errors)
      message.each do |key, errors_message|
        @errors << {
          reason: key.to_s,
          message: errors_message
        }
      end
    else
      @errors << message
    end
  end
end
