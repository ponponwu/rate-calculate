require 'nokogiri'
require 'open-uri'

class CountriesController < ApplicationController
  def index
    # 改成資料存入資料庫, 當下時間-update_date時間 >= 1 執行
    # else 資料庫抓資料顯示
    # @current_rate = CheckService.new.refresh_rate
    @attention = Attention.find_by_user_id(session[:user_id])

  end

  def select
    dollar_select = params[:country_cn]
    # country_select = ''
    country_select = params[:country].blank?? 'USD' : params[:country]
    bank_list = CheckService.new.select_country(country_select)
    respond_to do |format|
      format.js {
        @bank = bank_list
        @dollarSelect = dollar_select
        @better_sell = getCompare(0, bank_list)
        @better_buy = getCompare(1, bank_list)
      }
    end
  end

  def calculate
    @current_rate = CheckService.new.refresh_rate
    # @current_rate = Country.find_by(1).rate_array
    amount = params[:amount].to_f
    from_rate = @current_rate[params[:_from]].to_f
    to_rate = @current_rate[params[:_to]].to_f
    @cal = (amount * from_rate / to_rate).round(4)
  end
end
