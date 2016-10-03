class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  def getCompare(compare, *arr)
    bank = ''
    max = arr[0][0][:buy]
    min = arr[0][0][:sell]

    if compare==0
      bank = arr[0][0][:bank]
      arr[0].each_with_index do |r, idx|
        val = r[:buy]
        if val > max
          max = val
          bank = r[:bank]
        end
      end
      [bank,max]
    else
      bank = arr[0][0][:bank]
      arr[0].each_with_index do |r, idx|
        val = r[:sell]
        if val<min
          min = val
          bank = r[:bank]
        end
      end
      [bank,min]
    end
  end
  def set_newest_session_rate
    taiwanBank = []
    url = 'http://rate.bot.com.tw/Pages/Static/UIP003.zh-TW.htm'
    doc = Nokogiri::HTML(open(url))

    doc.css('.main tbody tr td.currency .hidden-phone.print_show').each_with_index do |r, index|
      taiwanBank << {
        'dollar' => r.children.text.strip[-4..-2],
        'buy_in' => index
      }
    end
    doc.css('.main tbody tr td:nth-child(3)').each_with_index do |r, index|
      taiwanBank[index]['buy_in'] = r.children.text
    end
    taiwanBank << {
      'dollar' => 'NTD',
      'buy_in' => 1
    }
    @taiwan = taiwanBank
    session[:rate] = Hash[taiwanBank.map { |d| [d['dollar'], d['buy_in']] }]
  end
  # 每一小時比對 目標金額與當下的匯率值 符合條件便寄出信件提醒 並將該筆記錄取消
  def attention_job
    @attention = Attention.where(is_enabled: true)
    @attention.each do |a|
      check_attention_and_send(a)
    end
  end

  def check_attention_and_send(attention)
    if session[:rate][currency] > attention.target_amount
      @user = User.find_by(attention.user_id)
      AttentionMailer.notify_attention_placed(@user, attention).deliver_now
      params_update = {is_enabled: false }
      update_attention_status(attention, params_update)
    end
  end

  def update_attention_status(attention, params)
    attention.update_attributes(params)
    # 要測試失敗會發生什麼
  end
  # model attention的user_id從1開始跑
  # is_enable = true, get currency, target_amount
  #
  # if session[:rate][currency] > target_amount
  # then mail
  # update is_enable = false
  #

end
