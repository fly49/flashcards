require 'rubygems'
require 'nokogiri'
require 'open-uri'

page = Nokogiri::HTML(open('https://www.en365.ru/top1000b.htm').read)
          
texts = page.css("tr").map(&:text)
        .grep(/\s\d{3}$\s/)                 # words located in str with 3 digit number
        .reject { |s| s.include?('вр') }    # reject strs like ""прич.прош.вр.от spend"
        .each_with_object({}) do |s, hash|
          s = s.split                                       # delete whitespaces
          original_text = s[1]  
          transcription = s[2]
          translated_text = s[3].gsub(/[^[:word:]\s]/, '')  # delete ',' and ';'
          hash[original_text] = transcription, translated_text
        end 
  
texts.each_pair do |key, value|
  Card.create(original_text: key, transcription: value.first,
              translated_text: value.second, review_date: Date.today + 3)
end
