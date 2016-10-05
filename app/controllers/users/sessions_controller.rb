class Users::SessionsController < Devise::SessionsController
  prepend_before_action :require_no_authentication, only: [:new, :create]
  prepend_before_action :allow_params_authentication!, only: :create
  prepend_before_action :verify_signed_out_user, only: :destroy
  prepend_before_action only: [:create, :destroy] { request.env["devise.skip_timeout"] = true }
  respond_to :json
  def new
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
    yield resource if block_given?
    respond_with(resource, serialize_options(resource))
    session[:user_id] = resource.id
  end

  def create
    Rails.logger.warn(" >>> Custom Create >>>")
    self.resource = warden.authenticate!(auth_options)
    Rails.logger.warn(resource.id)
    if resource
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)
      yield resource if block_given?
      respond_with resource, location: after_sign_in_path_for(resource)
      session[:user_id] = resource.id
    else
      Rails.logger.warn(" >>> Sign in Error >>>")
      puts "sign_in error"
      redirect_to root_path(msg: 'GOOD!')
    end
  end
  protected
  def after_sign_in_path_for(resource)
    # signed_in_root_path(resource)
    root_path
  end

end
