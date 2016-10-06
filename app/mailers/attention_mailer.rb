class AttentionMailer < ApplicationMailer
  def notify_attention_placed(user, attention, currency)
    @attention = attention
    @user = user
    @currency = 'country_categories.'+ @attention.currency
    mail(to: @user.email , subject: "[匯算網] [提醒] [您所加入的 #{I18n.t(@currency)}, 設立的目標 當下匯率 #{currency} 已低於#{@attention.target_amount}]")
  end
end
