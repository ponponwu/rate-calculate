class GoFailure < Devise::FailureApp
  def redirect_url
    Rails.logger.warn("1111111")
    root_path #改這行看你要去哪裡
  end
  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end
end
