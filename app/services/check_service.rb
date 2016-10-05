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
      'buy_in' => '1'
    }
    @tw = Hash[taiwan_bank.map { |d| [d['dollar'], d['buy_in']] }]
    attention_job
  end

  def attention_job
    @attention = Attention.where(is_enabled: true)
    @attention.each do |a|
      check_attention_and_send(a)
    end
  end

  def check_attention_and_send(attention)
    @currency = tw[attention.currency]
    if @currency.to_f > attention.target_amount.to_f
      @user = User.find_by(attention.user_id)
      AttentionMailer.notify_attention_placed(@user, attention, @currency).deliver_now
      params_update = {is_enabled: false }
      update_attention_status(attention, params_update)
    end
  end

  def update_attention_status(attention, params)
    attention.update_attributes(params)
    # 要測試失敗會發生什麼
  end

end
