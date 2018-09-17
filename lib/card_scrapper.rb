require 'rubygems'
require 'nokogiri'
require 'open-uri'

class CardScrapper
  def get_cards
    data = extract_page_data(get_page)
    save(data)
  end
  
  private
  
  def get_page
    Nokogiri::HTML(open('https://www.en365.ru/top1000b.htm').read)
  end
  
  def extract_page_data(page)
    page.css("tr").map(&:text)
      .grep(/\s\d{3}$\s/)                 # words located in str with 3 digit number
      .reject { |s| s.include?('вр') }    # reject strs like ""прич.прош.вр.от spend"
      .each_with_object([]) do |s, arr|
        s = s.split                       # delete whitespaces
        hash = { original_text: s[1], transcription: s[2],
                 translated_text: s[3].gsub(/[^[:word:]\s]/, '') }
        arr << hash
    end 
  end
  
  def save(data)
    data.each { |h| Card.create(h) }
  end
end
