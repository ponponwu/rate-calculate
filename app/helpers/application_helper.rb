module ApplicationHelper
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
  #/////////////////////devise//////////////////////////
  # def render_country_category(country)
  #   key = CountryData.country_categories.key(country.country_category)
  #   I18n.t("country_categories.#{key}")
  # end


  def attention_message
    attention_types = { attention_notice: :success, attention_alert: :danger }

    close_button_options = { class: "close", "data-dismiss" => "alert", "aria-hidden" => true }
    close_button = content_tag(:button, "×", close_button_options)

    alerts = flash.map do |type, message|
      #alert_content = close_button + message
      alert_content = message

      attention_type = attention_types[type.to_sym] || type
      alert_class = "alert alert-#{attention_type} alert-dismissable"
      alert_id = "alert-messages"
      content_tag(:div, alert_content, class: alert_class)
    end

    alerts.join("\n").html_safe
  end

  def notice_message
    alert_types = { notice: :success, alert: :danger }

    close_button_options = { class: "close", "data-dismiss" => "alert", "aria-hidden" => true }
    close_button = content_tag(:button, "×", close_button_options)

    alerts = flash.map do |type, message|
      if type == alert || type == notice
        alert_content = close_button + message

        alert_type = alert_types[type.to_sym] || type
        alert_class = "alert alert-#{alert_type} alert-dismissable"
        alert_id = "alert-messages"
        content_tag(:div, alert_content, class: alert_class)
      end
    end

    alerts.join("\n").html_safe
  end

  protected
  # def check_user_login!
  #   if !user_signed_in
  #     flash[:devise_alert] = "確實填寫欄位"
  #     render :_new
  #     # redirect_to login_path, :notice => 'if you want to add a notice'
  #     ## if you want render 404 page
  #     ## render :file => File.join(Rails.root, 'public/404'), :formats => [:html], :status => 404, :layout => false
  #   end
  # end

end
