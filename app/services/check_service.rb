class CheckService
  attr_accessor :tw
  # redable writable
  def initialize
    tw = []
  end

  def execute_check_job!
    refresh_rate
    attention_job
  end

  def refresh_rate
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
    tw = Hash[taiwan_bank.map { |d| [d['dollar'], d['buy_in']] }]
    Country.find_or_create_by(1).update!(rate_array: tw)
    # @tw = taiwan_bank
  end


  def attention_job
    @attention = Attention.where(is_enabled: true)
    @attention.each do |a|
      check_attention_and_send(a)
    end
  end

  def check_attention_and_send(attention)
    @currency = tw[attention.currency]
    if @currency.to_f < attention.target_amount.to_f
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


  # 把銀行的放到db id2
  # 每小時執行一次
  def select_country(country_select)
    url = 'http://www.taiwanrate.org/exchange_rate.php?c=USD#.VwlFMhJ95TY'
    url.gsub!(/c=\w\w\w/, "c=#{country_select}")
    doc = Nokogiri::HTML(open(url))
    bank_list = []
    doc.css('#markup table tbody tr td:nth-child(1)').each_with_index do |r, idx|
      bank_list.push(
        bank: r.children.text,
        buy: idx,
        sell: idx
      )
    end
    doc.css('#markup table tbody tr td:nth-child(2)').each_with_index do |r, idx|
      bank_list[idx][:buy] = r.children.text
    end
    doc.css('#markup table tbody tr td:nth-child(3)').each_with_index do |r, idx|
      bank_list[idx][:sell] = r.children.text
    end
    bank_list
    # _HTML = doc.css('body h1').text
    # @title = _HTML
    # max = bankList.min_by {|bank, buy| buy }
    # max = bankList.max_by(&:buy)
  end

end
