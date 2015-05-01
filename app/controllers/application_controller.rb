require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :set_locale
  before_filter :configure_devise_permitted_parameters, if: :devise_controller?

  helper_method :current_project

  def after_sign_in_path_for(resource)
    user_projects_path(resource)
  end

  protected

  def current_project
    if (params[:project_id])
      Project.find(params[:project_id])
    end
  end

  def validate_user
    if params[:user_id]
      user = User.find(params[:user_id])
      if user != current_user
        flash[:alert] = t('.restricted_access')
        redirect_to root_url
      end
    end
  end

  def configure_devise_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :password, :password_confirmation) }
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options = {})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { locale: I18n.locale }
  end
end
