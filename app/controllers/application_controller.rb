class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  # ======deviseログイン後の遷移先設定======
  def after_sign_in_path_for(resource)
    mypage_path
  end

  #===deviseのストロングパラメーター======
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :name,
      :email,
      :profile_image,
      :cover_image,
      :area,
    ])
  end
end
