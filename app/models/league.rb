require 'scraper'
class League < ActiveRecord::Base
    has_many :team, inverse_of: :league, dependent: :destroy
    has_many :players, dependent: :destroy
    has_many :trade_sheets, inverse_of: :league, dependent: :destroy

    def scrape_league
      if self.site == 'NFL'
        league_scraper = SCRAPERS::NFLScraper.new(self.number, '10')
        rankings_scraper = SCRAPERS::FantasyProsScraper.new
      else 
        puts 'NFL.com is currently the only active site for this tool'
      end

      rankings_scraper.scrape_player_values
      league_scraper.scrape_teams_info
      league_scraper.scrape_players

      make_teams(league_scraper.get_league_size,
                 league_scraper.get_players,
                 league_scraper.get_teams,
                 rankings_scraper.get_player_list)
    end

    def make_teams(size, scraped_players, scraped_teams, scraped_values)
      (0..size).each do |team_number|
          name = scraped_teams.select{|t| t[:number] == team_number}.first&.[](:name) || 'Waiver Wire'

          team = Team.create(league: self, number: team_number, name: name)
          team.make_players(scraped_players, scraped_values)
      end
    end
end
