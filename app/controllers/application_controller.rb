class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

    private

    #===deviseのストロングパラメーター======
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys:[
        :name,
        :email,
        :profile_image,
        :cover_image,
        :area,
      ])
    end
end
