require 'nokogiri'
require 'open-uri'

class ComicsController < ApplicationController

	def index
		url = 'http://www.taiwanrate.org/exchange_rate.php?c=USD#.VwlFMhJ95TY'
	 	doc = Nokogiri::HTML(open( url ))

		bankList =[]
		doc.css('table table tbody tr td:nth-child(1)').each_with_index do |r,idx|
			bankList.push(
				:bank => r.children.text,
				:buy => idx,
				:sell => idx
			)
		end

    doc.css('table table tbody tr td:nth-child(2)').each_with_index do |r,idx|
			bankList[idx][:buy] = r.children.text
		end
		doc.css('table table tbody tr td:nth-child(3)').each_with_index do |r,idx|
			bankList[idx][:sell] = r.children.text
		end
		@bank = bankList

		_HTML = doc.css('body h1').text
		@title = _HTML
		@max = bankList.max_by {|bank, buy| buy }
		# people.min_by { |name, age| age } #=> ["joe", 21]
	end

	def comicList
	url ='http://comic.sfacg.com/'
	doc = Nokogiri::HTML(open( url ))

	_HTML = doc.xpath( "//img/@src" ).text.split('http:')
	@title = _HTML.shift
	@comics = _HTML
	#comicList =[]

	#_HTML.each_with_index do |r,idx|

    #  if idx > 0
    #    comicList.push(r)
    #  end
    #end

	#@comics = _HTML
	end
end
