module Synchronizers
  class ProductsSynchronizerController < ApplicationController
    def index
      Synchronizers::ProductsSynchronizer.call
      flash[:success] = "Product Synchronizer Successfully"
    end
  end
end
