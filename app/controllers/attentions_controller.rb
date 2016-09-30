class AttentionsController < ApplicationController
  before_action :authenticate_user!
  def new
    #@attention = Attention.new
  end

  def new_release
    respond_to do |format|
      # format.html
      format.js
    end
  end

  def create

    @attention = current_user.attentions.build(attention_params)

    @old_attention = Attention.where(user_id: session["warden.user.user.key"][0][0], is_enabled: true, currency: @attention.currency)
    if !@old_attention.blank?
      #find and update
      respond_to do |format|
        if @old_attention.update(attention_params)
          format.html { redircet_to attentions_path}
        else

        end
      end
    else
      if @attention.save
        Rails.logger.warn(" >>> 12123 Create >>>")

        flash[:notice] = "新增成功"
        redirect_to attentions_path
      else
        flash[:attention_alert] = "確實填寫欄位"
        #render :_new
        #render 後為何底部是index的頁面
        respond_to do |format|
          format.html{ render :_new }
          format.js{ render file: '/attentions/create.js.haml' }
        end
      end
    end#if

  end


  def update

  end

  def index
    @attentions = Attention.where(user_id: session["warden.user.user.key"][0][0], is_enabled: true)
  end

  private
  def attention_params
    params.require(:attention).permit(:currency, :target_amount)
  end


end
