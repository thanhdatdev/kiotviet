module Synchronizers
  class UsersSynchronizerController < ApplicationController
    def index
      Synchronizers::UsersSynchronizer.call
      flash[:success] = "Users Synchronizer Successfully"
      redirect_to roor_path
    end
  end
end
