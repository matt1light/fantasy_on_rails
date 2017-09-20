require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper
  def initialize
    @url
    @page
  end
  
  def open_page(url)
   @page = Nokogiri::HTML(open(url)) 
  end

  def get_url
    @url
  end

  def get_page
    @page
  end
end

class RankingsScraper < Scraper
  def initialize
    super
    @playerlist = []
  end

  def get_player_list
    return @playerlist
  end
end

class CBSScraper < RankingsScraper
  
end

class FantasyProsScraper < RankingsScraper
  def initialize
    super
    @url = 'https://www.fantasypros.com/2017/09/fantasy-football-trade-values-week-2/'
  end
  
  def find_player_list
    # sets @page to the HTML Document
    open_page(@url)
    # Finds all the tables
    tables = @page.css("table")
    # finds the rows that have players in them
    rows = tables.css('tr').select{|r| r.children[1]&.children[0]&.[]('class')&.include?("fp-player-link")}
    # for each of those rows find the player and his value
    rows.each do |row|
      name = row.children[1].children[0].text
      value = row.children[3].text
      # add those players to an array of hashes
      @playerlist << {name: name, value: value}
    end
  end
end

class LeagueScraper < Scraper

end

class NFLScraper < LeagueScraper

end

class YahooScraper < LeagueScraper

end

class ESPNScraper < LeagueScraper

end

fs = FantasyProsScraper.new
fs.find_player_list
print fs.get_player_list[5]
