class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?

  def authorize_request(kind = nil)
    unless kind.include?(current_user.role)
      flash[:alert] = "NO ESTÁ AUTORIZADO PARA REALIZAR ESTA ACCION"
      redirect_to root_path
    end
  end

  protected

  def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [ :name, :telephone, :picture, :role ])
      devise_parameter_sanitizer.permit(:account_update, keys: [ :name, :telephone, :picture, :role ])
  end

  def after_sign_in_path_for(resource)
    root_path
  end
end
