class ApplicationController < ActionController::Base
  # before_action :kiotviet_oauth2

  def kiotviet_oauth2
    ApiClients::KiotvietClient.call
    flash[:success] = 'OAuth Successfully'
  end
end
