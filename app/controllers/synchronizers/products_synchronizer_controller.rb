module Synchronizers
  class ProductsSynchronizerController < ApplicationController
    def index
      Synchronizers::ProductsSynchronizer.call
      flash[:success] = "Product Synchronizer Successfully"
      redirect_to roor_path
    end
  end
end
