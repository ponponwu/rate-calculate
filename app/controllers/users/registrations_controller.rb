class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json
  def create
    build_resource(sign_up_params)
    resource.save
    yield resource if block_given?
    Rails.logger.warn(" >>> 1 >>>")
    if resource.persisted?
      Rails.logger.warn(" >>> 2 >>>")
      if resource.active_for_authentication?
        Rails.logger.warn(" >>> 3 >>>")
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        Rails.logger.warn(" >>> 4 >>>")
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      Rails.logger.warn(resource)
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end


private
  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :image, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :email, :image, :password, :password_confirmation, :current_password)
  end
end
