# reference to country_data
class Country < ActiveRecord::Base
  has_many :attention
  serialize :rate_array, Hash
  def self.categories
    CountryData.country_categories.map{ |k, v| [I18n.t("country_categories.#{k}"), k]}
  end
  # 
  # private
  # def update_or_create(attributes)
  #   assign_or_new(attributes).save
  # end
  #
  # def self.assign_or_new(attributes)
  #   obj = first || new
  #   obj.assign_attributes(attributes)
  #   obj
  # end



end
