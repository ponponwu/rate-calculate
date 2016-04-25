class Country < ActiveRecord::Base
  def self.categories
    CountryData.country_categories.map{ |k,v| [I18n.t("country_categories.#{k}"),v] }
  end

end
