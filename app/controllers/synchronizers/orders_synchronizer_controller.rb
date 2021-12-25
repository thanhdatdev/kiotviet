module Synchronizers
  class OrdersSynchronizerController < ApplicationController
    def index
      # Synchronizers::OrdersSynchronizer.call
      OrdersSynchronizerWorker.perform_async
      flash[:success] = "Orders Synchronizer Successfully"
      redirect_to root_path
    end
  end
end
