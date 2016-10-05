class AttentionMailer < ApplicationMailer
  def notify_attention_placed(user, attention, currency)
    @attention = attention
    @user = user
    @currency = 'country_categories.'+ @attention.currency
    mail(to: @user.email , subject: "[匯算網] [提醒] [您所加入的 #{I18n.t(@currency)} 您所設立的目標 #{@attention.target_amount} 已低於當下匯率 #{currency}]")
  end
end
