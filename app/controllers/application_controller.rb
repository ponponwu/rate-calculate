class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  def getCompare(compare,*arr)
    bank = ''
    max = arr[0][0][:buy]
    min = arr[0][0][:sell]

    if compare==0
      arr[0].each_with_index do |r,idx|
        val = r[:buy]
        if val>max
          max = val
          bank = r[:bank]
        end
      end
      [bank,max]
    else
      arr[0].each_with_index do |r,idx|
        val = r[:sell]
        if val<min
          min = val
          bank = r[:bank]
        end
      end
      [bank,min]
    end
  end
end
