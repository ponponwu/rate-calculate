class CountryData < Settingslogic
  source "#{Rails.root}/config/country.yml"
  namespace Rails.env
end
