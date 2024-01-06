class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :check_user_activation, unless: :devise_controller?
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  def check_user_activation
    return if user_active? || on_sign_in_page?

    redirect_to dashboard_path, alert: 'Your account is not active.'
  end

  def user_active?
    current_user && current_user.active?
  end

  def on_sign_in_page?
    # Customize the condition based on your sign-in page route or controller action
    request.path == dashboard_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def after_sign_in_path_for(resource)
    if current_user.admin?
      agents_path
    else
      dashboard_path
    end
  end

  private

  def user_not_authorized
    redirect_to root_path, alert: 'You are not authorized to perform this action.'
  end
end
