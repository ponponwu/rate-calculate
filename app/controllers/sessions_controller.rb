class SessionsController < Devise:: SessionsController
  respond_to :html, :json

  # def create
  #   if :unauthorized
  #     respond_to do |format|
  #       format.js {
  #         flash[:notice] = "Invalid email or password"
  #         render :template => "countries/devise_errors.js.erb"
  #         flash.discard
  #       }
  #     end
  #   else
  #     self.resource = warden.authenticate!(auth_options)
  #     sign_in(resource_name, resource)
  #     yield resource if block_given?
  #     respond_with resource, location: after_sign_in_path_for(resource)
  #   end
  #
  # end
end
