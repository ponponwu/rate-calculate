# atteintion for rate
class AttentionsController < ApplicationController
  before_action :authenticate_user!

# CLIENT SIDE ALIDATIONS
  # create attention
  def create
    @attention = current_user.attentions.build(attention_params)
    @currency = @attention.currency
    @userId = session["warden.user.user.key"][0][0]
    @old_attention = Attention.find_by(user_id: @userId, is_enabled: true, currency: @currency)

    # if !@old_attention.blank? && !attention_params["target_amount"].blank?
    if @old_attention.present? && attention_params["target_amount"].present?
      # find and update
      respond_to do |format|
        if @old_attention.update(attention_params)
          format.html { redirect_to attentions_path, notice: "已將" + I18n.t("country_categories.#{@currency}") + "修改完成"}
        end
      end
    else
      respond_to do |format|
        if @attention.save
          format.html { redirect_to attentions_path, notice: "已將" + I18n.t("country_categories.#{@currency}") + "加入清單" }
          # format.js{ render 'show', status: :created, location: @attention}
        else
          # format.html { render action: 'new' }
          # format.json { render json: @attention.errors, status: :unprocessable_entity }
          format.js{ render json: @attention.errors, status: :unprocessable_entity }
        end
      end
    end # if
  end


  def index
    @attention = Attention.new
    @attentions = Attention.where(user_id: session["warden.user.user.key"][0][0], is_enabled: true)
  end

private

  def attention_params
    params.require(:attention).permit(:currency, :target_amount)
  end
end
