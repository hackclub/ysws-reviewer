class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]
  layout "auth", only: [:new]

  def new
    redirect_to authenticated_root_path if user_signed_in?
  end

  def create
    auth = request.env["omniauth.auth"]
    slack_user_id = auth["uid"]

    unless AuthorizedUser.exists?(slack_user_id: slack_user_id)
      reset_session
      redirect_to login_path, alert: "You are not authorized to access this application."
      return
    end

    session[:user_slack_id] = slack_user_id
    session[:user_info] = {
      name: auth.info.name,
      email: auth.info.email,
      image: auth.info.image
    }

    redirect_to authenticated_root_path, notice: "Successfully signed in!"
  end

  def destroy
    reset_session
    redirect_to login_path, notice: "Successfully signed out."
  end
end 