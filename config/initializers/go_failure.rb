class GoFailure < Devise::FailureApp
  def redirect_url
    Rails.logger.warn("1111111")
    session[:modal] = true
    :back
  end
  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end
end
