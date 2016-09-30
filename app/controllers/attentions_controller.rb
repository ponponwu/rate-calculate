class AttentionsController < ApplicationController
  before_action :authenticate_user!
  def new
    #@attention = Attention.new
  end

  def create

    @attention = current_user.attentions.build(attention_params)

    if @attention.save
      flash[:notice] = "新增成功"
      redirect_to attentions_path
    else
      flash[:notice] = "確實填寫欄位"
      render :new
    end
  end

  def index
    @attentions = Attention.where(user_id: session["warden.user.user.key"][0][0])
  end

  def update

  end


  private
  def attention_params
    params.require(:attention).permit(:currency, :target_amount)
  end


end
