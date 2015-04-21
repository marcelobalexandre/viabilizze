class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :set_locale
  before_filter :configure_devise_permitted_parameters, if: :devise_controller?
  
  def after_sign_in_path_for(resource)
    user_projects_path(resource)
  end

  protected

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

  def validate_user
    if params[:user_id]
      @user = User.where(id: params[:user_id]).first
      if @user != current_user
        flash[:alert] = t('.restricted_access')
        redirect_to root_url
      end      
    end
  end
end
