require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'pry'
require 'pry-byebug'
require 'launchy'

module SCRAPERS
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
      @playerlist
    end
  end

  class CBSScraper < RankingsScraper
    
    def scrape_player_values
    end
  end

  class FantasyProsScraper < RankingsScraper
    def initialize
      super
      make_url(4)
    end

    def make_url(week)
      #TODO Make it handle other months!!!
      @url = 'https://www.fantasypros.com/2017/09/fantasy-football-trade-values-week-' + week.to_s
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
      @teams = []
      @players = []
      @league_size = 0
    end

    def scrape_players
      i = 1
      @league_size.times do
        scrape_team(i)
        i += 1
      end
      #TODO: add function to determine week and year and unhardcode it
      scrape_waivers(3, 2017)
    end
    
    def scrape_waivers(week, year)
      make_urls(week, year).each do |url|
        scrape_waiver_page(url)
      end
    end

    def get_players
      @players
    end

    def get_teams
      @teams
    end
    
    def get_league_size
      @league_size
    end
  end

  class NFLScraper < LeagueScraper
    def initialize(league, team)
      super(league, team)
    end
    
    def scrape_teams_info
      url = 'http://fantasy.nfl.com/league/' + @league.to_s

      page = open_page(url)

      rows = page.css('tr').select{|t| t['class'].include?('team-')}

      rows.each do |row|
        name = row.css('a').select{|a| a['class'].include?('teamName')}.first.text
        record = row.css('td').select{|td| td['class'].include?('teamRecord')}.first.text
        image = row.css('img').first['src']

        class_name = row['class']
        number = class_name[class_name.index('-') + 1..class_name.index(' ')].to_i

        @league_size += 1
        @teams << {name: name, record: record, image: image, number: number}
      end
    end

    def scrape_team(number) 
      url = 'http://fantasy.nfl.com/league/' + @league.to_s + '/team/' + number.to_s
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
        if !position_team.include?('-')
          position = position_team
          team_name = nil
        else
          # if it is not a defense split the text into position and team
          position = position_team.slice(0..(position_team.index(' ') - 1))
          team_name = position_team.slice((position_team.index('-') + 2)..-1)
        end
        # add a hash with all of these values to the players array
        @players << {name: name, position: position, team: number, nflteam: team_name}
      end
    end


    def scrape_waiver_page(url)
      page = open_page(url)
      rows = page.css('td').select{|c| c['class'].include?('playerNameAndInfo')}
      rows.each do |playerNameAndInfo|
        name = playerNameAndInfo.css('a').select{|c| c['class'].include?('playerName')}[0]&.text
        position_team = playerNameAndInfo.css('em').text
        if !position_team.include?('-')
          position = position_team
          team_name = nil
        else
          # if it is not a defense split the text into position and team
          position = position_team.slice(0..(position_team.index(' ') - 1))
          team_name = position_team.slice((position_team.index('-') + 2)..-1)
        end
        # add a hash with all of these values to the players array
        @players << {name: name, position: position, team: 0, nflteam: team_name}
      end
    end

    def make_urls(week, year)
      urls = []
      # each of these numbers represents a position
      # 1: qb
      # 2: WR
      # 3: RB
      # 4: TE
      # 5: WR/RB
      # 7: Kicker
      # 8: Defense
      [1, 2, 3, 4, 7, 8].each do |position_number|
        url = 'http://fantasy.nfl.com/league/' +
              @league.to_s + 
              '/players?_selectedColumnSortOrder_=desc&playerStatus=available&position=' +
              position_number.to_s + 
              '&sort=percentOwned&statCategory=research&statSeason=' +
              year.to_s + 
              '&statWeek=' +
              week.to_s
        urls << url
      end
      urls
    end
    # URLS are from NFL.com free agents list ordered by % ownership
  end

  class YahooScraper < LeagueScraper

  end

  class ESPNScraper < LeagueScraper

  end
end
