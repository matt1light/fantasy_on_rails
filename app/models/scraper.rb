require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'pry'
require 'pry-byebug'

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
  
  def scrape_player_values
  end
end

class FantasyProsScraper < RankingsScraper
  def initialize
    super
    @url = 'https://www.fantasypros.com/2017/09/fantasy-football-trade-values-week-2/'
  end
  
  def scrape_player_values
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
  def initialize(league, team)
    super()
    @league = league
    @team = team
    @players = []
  end

end

class NFLScraper < LeagueScraper
  def initialize(league, team)
    super(league, team)
  end
  
  def scrape_team(number) 
    url = 'http://fantasy.nfl.com/league/' + @league + '/team/' + number 
    #opens the team page as HTML
    page = open_page(url)
    #gets the list of every row with a player in it
    rows = page.css('tr').select{|row| row['class'].include?('player-')}
    # For each row
    rows.each do |row|
      # Skip the extra row without a player
      next if row&.[]('class')&.include?('benchLabel')
      # find the table elements
      elements = row.css('td')
      # find the name of the player in this row
      name = elements.css('a').select{|a| a['class']&.include?('playerCard')}&.first&.text
      # finds the element that has both the position name and the team name
      position_team = elements.css('em').text
      next if position_team.empty?
      # if the player is a defense then it has no team value
      if position_team == 'DEF'
        position = position_team
        team = nil
      else
        # if it is not a defense split the text into position and team
        position = position_team.slice(0..(position_team.index(' ') - 1))
        team_name = position_team.slice((position_team.index('-') + 2)..-1)
      end
      # add a hash with all of these values to the players array
      @players << {name: name, position: position, team: number, nflteam: team_name}
    end
  end
end

class YahooScraper < LeagueScraper

end

class ESPNScraper < LeagueScraper

end

ls = NFLScraper.new('4430415', '10')
ls.scrape_team('1')
# fs = FantasyProsScraper.new
# fs.find_player_list
# print fs.get_player_list[5]
