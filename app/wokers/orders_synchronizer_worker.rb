# frozen_string_literal: true

class OrdersSynchronizerWorker < BaseWorker
  def perform
    Synchronizers::OrdersSynchronizer.call
  end
end
