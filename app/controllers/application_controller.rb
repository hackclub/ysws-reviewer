class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :authenticate_user!

  helper_method :current_user, :user_signed_in?

  private

  def authenticate_user!
    unless user_signed_in?
      redirect_to login_path, alert: "Please sign in to continue."
    end
  end

  def current_user
    return nil unless session[:user_slack_id]
    
    @current_user ||= AuthorizedUser.find_by(slack_user_id: session[:user_slack_id])
  end

  def user_signed_in?
    current_user.present?
  end

  def user_info
    session[:user_info] || {}
  end
  helper_method :user_info
end
