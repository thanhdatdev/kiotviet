module Synchronizers
  class ProductsSynchronizerController < ApplicationController
    def index
      Synchronizers::OrdersSynchronizer.call
      flash[:success] = "Orders Synchronizer Successfully"
      redirect_to root_path
    end
  end
end
