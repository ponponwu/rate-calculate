require 'nokogiri'
require 'open-uri'

class CountriesController < ApplicationController
  def index
    # 改成資料存入資料庫, 當下時間-update_date時間 >= 1 執行
    # else 資料庫抓資料顯示
    @current_rate = CheckService.new.refresh_rate
    @attention = Attention.find_by_user_id(session[:user_id])
  end


private
  def select
    dollar_select = params[:country_cn]
    country_select = ''
    params[:country].blank? country_select = 'USD' ! country_select = params[:country]


    url = 'http://www.taiwanrate.org/exchange_rate.php?c=USD#.VwlFMhJ95TY'
    url.gsub!(/c=\w\w\w/, "c=#{countrySelect}")
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
    @bank = bank_list

    _HTML = doc.css('body h1').text
    @title = _HTML
    # max = bankList.min_by {|bank, buy| buy }
    # max = bankList.max_by(&:buy)

    respond_to do |format|
      format.js {
        @bank = bank_list
        @dollarSelect = dollar_select
        # @title = _HTML;
        @better_sell = getCompare(0, bank_list)
        @better_buy = getCompare(1, bank_list)
      }
    end
  end

  def calculate
    amount = params[:amount].to_f
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
