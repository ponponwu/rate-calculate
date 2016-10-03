class AttentionMailer < ApplicationMailer
  def notify_attention_placed(user, attention)
    # @order       = order
    # @user        = order.user
    # @order_items = @order.items
    # @order_info  = @order.info
    @attention = attention
    @user = user
    mail(to: @user.email , subject: "[匯算網] [提醒] [您所加入的 #{@attention.currency}當下匯率已低於您所設立的目標#{@attention.target_amount} ]")
  end
end
