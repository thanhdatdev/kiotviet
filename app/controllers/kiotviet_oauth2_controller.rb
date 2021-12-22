class KiotvietOauth2Controller < ApplicationController
  def new; end

  def create
      service = ApiClients::KiotvietClient.call(params)
      session[:access_token] = service.result
      flash[:notice] = "Logged in successfully."
      redirect_to root_path
      flash.now[:alert] = "There was something wrong with your login details."
      render 'new'
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "You have been logged out."
    redirect_to root_path
  end
end
