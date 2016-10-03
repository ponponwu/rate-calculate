# reference to country_data
class Country < ActiveRecord::Base
  has_many :attention
  def self.categories
    CountryData.country_categories.map{ |k, v| [I18n.t("country_categories.#{k}"), k]}
  end

end
