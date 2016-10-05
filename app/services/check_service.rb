class CheckService
  attr_accessor :tw
  # redable writable
  def initialize
    @tw = []
  end

  def refresh_rate!
    taiwan_bank = []
    url = 'http://rate.bot.com.tw/Pages/Static/UIP003.zh-TW.htm'
    doc = Nokogiri::HTML(open(url))

    doc.css('.main tbody tr td.currency .hidden-phone.print_show').each_with_index do |r, index|
      taiwan_bank << {
        'dollar' => r.children.text.strip[-4..-2],
        'buy_in' => index
      }
    end
    doc.css('.main tbody tr td:nth-child(3)').each_with_index do |r, index|
      taiwan_bank[index]['buy_in'] = r.children.text
    end
    taiwan_bank << {
      'dollar' => 'NTD',
      'buy_in' => 1
    }
    @taiwan = taiwan_bank
    # updae db
    # session[:rate] = Hash[taiwanBank.map { |d| [d['dollar'], d['buy_in']] }]
  end

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

end
