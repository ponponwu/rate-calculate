module CountriesHelper


  def my_country_select(title, target_id , objs)
    html = '<div class="clearfix"><label for='+target_id+'">'+title+'</label><div class="input">'
    html += '<select id="'+target_id+'">'
    objs.each do |obj|
      html += '<option value="'+obj[1]+'">'+obj[0]+'</option>'
    end
    html += '</select></div></div>'
    return raw(html)
  end

  def image_link(pic , title , value)
     link_to image_tag(pic,{ size: "50x30" }) + tag(:br) + title ,'javascript:;',{ class: "country img-responsive", :"data-value" => value }
  end


end
