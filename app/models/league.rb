require 'scraper'
class League < ActiveRecord::Base
    has_many :team, inverse_of: :league, dependent: :destroy
    has_many :players, dependent: :destroy

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

      make_teams(league_scraper.get_league_size, league_scraper.get_players, league_scraper.get_teams, rankings_scraper.get_player_list)
    end

    def make_teams(size, scraped_players, scraped_teams, scraped_values)
      (0..size).each do |team_number|
          name = scraped_teams.select{|t| t[:number] == team_number}.first&.[](:name) || 'Waiver Wire'

          team = Team.create(league: self, number: team_number, name: name)
          team.make_players(scraped_players, scraped_values)
      end
    end

    def one_for_one_trades(team1, team2)
      old_total = team1.get_starters_total
      team1.player.each do |player1|
        team2.player.each do |player2|
          trade = swap_and_recalc(team1, team2, [player1], [player2])
          if trade[:total_value] > old_total
            Trade.create(league_id: self.id,
                         my_value: trade[:value1], 
                         other_value: trade[:value2], 
                         player: [player1, player2])
          end
        end
      end
    end

    def swap_and_recalc(team1, team2, players1, players2)
      total = 0
      players1.each do |player|
        player.update(team: team2)
      end
      players2.each do |player|
        player.update(team: team1)
      end
      team1.set_starters
      team2.set_starters
      team1Value = team1.get_starters_total
      team2Value = team2.get_starters_total
      players1.each do |player|
        player.update(team: team1)
      end
      players2.each do |player|
        player.update(team: team2)
      end
      {value1: team1Value, value2: team2Value, total_value: team1Value + team2Value}
    end
end
