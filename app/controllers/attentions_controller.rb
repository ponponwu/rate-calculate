# atteintion for rate
class AttentionsController < ApplicationController
  before_action :authenticate_user!

  def new_release
    respond_to do |format|
      # format.html
      format.js
    end
  end
# CLIENT SIDE ALIDATIONS
  # create attention
  def create
    @attention = current_user.attentions.build(attention_params)
    @currency = @attention.currency
    @userId = session["warden.user.user.key"][0][0]
    @old_attention = Attention.find_by(user_id: @userId, is_enabled: true, currency: @currency)
    if !@old_attention.blank?
      # find and update
      respond_to do |format|
        if @old_attention.update(attention_params)
          flash[:notice] = "已將" + @currency + "修改完成"
          format.html { redirect_to attentions_path}
        else
          flash[:notice] = "請重試"
          render :back
        end
      end
    else
      if @attention.save
        flash[:notice] = '新增成功'
        redirect_to attentions_path
      else
        flash[:attention_alert] = '確實填寫欄位'
        # render :_new
        # render 後為何底部是index的頁面
        respond_to do |format|
          # format.html{render :_new }
          format.js{render file: '/attentions/create.js.haml' }
        end
      end
    end # if
  end


  def index
    @attention = Attention.new
    @attentions = Attention.where(user_id: session["warden.user.user.key"][0][0], is_enabled: true)
    @test = session[:rate]
  end

  private

  def attention_params
    params.require(:attention).permit(:currency, :target_amount)
  end
end
