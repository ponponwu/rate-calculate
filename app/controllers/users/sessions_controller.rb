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
    Rails.logger.warn(" >>> create >>>")
    self.resource = warden.authenticate!(auth_options)
    if resource
      logger.debug("#{resource}")
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)
      yield resource if block_given?
      respond_with resource, location: after_sign_in_path_for(resource)
      # respond_with(resource) do |format|
      #   format.js{ render 'show', status: :created, location: after_sign_in_path_for(resource)}
      # end
    else
      # logger.error(resource)
      # redirect_to root_path(msg: 'GOOD!')
      respond_to do |format|
        format.js{ render json: resource.inactive_message, status: :unprocessable_entity }
      end
    end
  end
  protected
  def after_sign_in_path_for(resource)
    # signed_in_root_path(resource)
    root_path
  end
  def invalid_login_attempt
    set_flash_message(:alert, :invalid)
    render json: flash[:alert], status: 401
  end

end
