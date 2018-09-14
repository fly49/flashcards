require 'rubygems'
require 'nokogiri'
require 'open-uri'

page = Nokogiri::HTML(open('https://www.en365.ru/top1000b.htm').read)
texts = page.css("tr").map(&:text).grep(/\s\d{3}$\s/).drop(1)
            .each_with_object(Hash.new(0)) do |s, hash|
              original_text = s.gsub(/\s+/, '')[/\d{3}(.*?)\[/m, 1]
              translated_text = s.gsub(/\s+/, '')
              hash[original_text] = translated_text[/(.*?)/m, 1]
              end 
p texts              
              
#Country.create(original_text: 'Germany', translated_text: 81831000, review_date: Date.today + 3)