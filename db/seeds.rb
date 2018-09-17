require 'rubygems'
require 'nokogiri'
require 'open-uri'

page = Nokogiri::HTML(open('https://www.en365.ru/top1000b.htm').read)
texts = page.css("tr").map(&:text)
        .grep(/\s\d{3}$\s/)              # words located in str with 3 digit number
        .reject { |s| s.include?('вр') } # reject strs like ""прич.прош.вр.от spend"
        .each_with_object({}) do |s, hash|
          s.gsub!(/\s+/, '')                    # delete whitespaces
          original_text = s[/\d{3}(.*?)\[/m, 1] # ...123(text)[...
          translated_text = s[/\](.*?)$/m, 1]   # ...](text)\n
          hash[original_text] = translated_text
        end 
          
texts.each do |text|
  Card.create(original_text: text.first, translated_text: text.second, review_date: Date.today + 3)
end
