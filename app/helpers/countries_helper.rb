module CountriesHelper
  def render_country_category(country)
    key = CountryData.country_categories.key(country.country_category)
    I18n.t("country_categories.#{key}")
  end

  def my_country_select(title, target_id , objs)
    html = '<div class="clearfix"><label for="normalSelect">'+title+'</label><div class="input">'
    html += '<select name="normalSelect" id="'+target_id+'">'
    objs.each do |obj|
      html += '<option value="'+obj[1]+'">'+obj[0]+'</option>'
    end
    html += '</select></div></div>'
    return raw(html)
  end


end
