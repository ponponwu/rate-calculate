require 'nokogiri'
require 'open-uri'

class CountriesController < ApplicationController
  def index
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
    @attention = Attention.find_by_user_id(session[:user_id])
  end

  def select
    dollarSelect = params[:country_cn]
    countrySelect = ''
    if params[:country].blank?
      countrySelect = 'USD'
    else
      countrySelect = params[:country]
    end

    url = 'http://www.taiwanrate.org/exchange_rate.php?c=USD#.VwlFMhJ95TY'
    url.gsub!(/c=\w\w\w/, "c=#{countrySelect}")
    doc = Nokogiri::HTML(open(url))

    bankList = []
    doc.css('#markup table tbody tr td:nth-child(1)').each_with_index do |r, idx|
      bankList.push(
        bank: r.children.text,
        buy: idx,
        sell: idx
      )
    end

    doc.css('#markup table tbody tr td:nth-child(2)').each_with_index do |r, idx|
      bankList[idx][:buy] = r.children.text
    end
    doc.css('#markup table tbody tr td:nth-child(3)').each_with_index do |r, idx|
      bankList[idx][:sell] = r.children.text
    end
    @bank = bankList

    _HTML = doc.css('body h1').text
    @title = _HTML
    # max = bankList.min_by {|bank, buy| buy }
    # max = bankList.max_by(&:buy)

    respond_to do |format|
      format.js {
        @bank = bankList
        @dollarSelect = dollarSelect
        # @title = _HTML;
        @better_sell = getCompare(0, bankList)
        @better_buy = getCompare(1, bankList)
      }
    end
  end

  def calculate
    amount = params[:amount].to_f
    # @cal = session[:rate][params[:_from]]
    # my_hash.select{|name, gender| gender == "male" }
    from_rate = session[:rate][params[:_from]].to_f
    to_rate = session[:rate][params[:_to]].to_f
    @cal = (amount * from_rate / to_rate).round(4)
  end
end

# model attention的user_id從1開始跑
# is_enable = true, get currency, target_amount
#
# if session[:rate][currency] > target_amount
# then mail
# update is_enable = false
#
