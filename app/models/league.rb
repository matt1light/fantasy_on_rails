require 'scraper'
class League < ActiveRecord::Base
    has_many :team, inverse_of: :league
    has_many :players

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
          binding.pry
          name = scraped_teams.select{|t| t[:number] == team_number}.first&.[](:name) || 'Waiver Wire'

          team = Team.create(league: self, number: team_number, name: name)
          team.make_players(scraped_players, scraped_values)
      end
    end

    def import_league(size)
      self.get_free_agents
      self.get_all_teams(size)
      (1..size).each do |t|
        Team.find_by(league: self, number: t).normalize_values
      end
    end

    # def make_url(position)
    #     if position == 'QB'
    #         if self.site == 'NFL'
    #             return 'http://fantasy.nfl.com/league/' + self.number.to_s + '/players?playerStatus=available&position=1&statCategory=stats&statSeason=2016&statType=fourWeekStats&statWeek=10#playersHomeList=playersHomeList%2C%2Fleague%2F4430415%2Fplayers%253FplayerStatus%253Davailable%2526position%253D1%2526sort%253Dpts%2526statCategory%253Dstats%2526statSeason%253D2016%2526statType%253DfourWeekStats%2Creplace'
    #         elsif self.site == 'ESPN'
    #             return 'http://games.espn.com/ffl/freeagency?leagueId=' + self.number.to_s + '&seasonId=2016#&seasonId=2016&slotCategoryId=0'
    #         elsif self.site =='Yahoo'
    #             return 'https://football.fantasysports.yahoo.com/f1/' + self.number.to_s + '/players?&sort=PR&sdir=1&status=A&pos=QB&stat1=S_S_2016&jsenabled=1'
    #         end
    #     elsif position == 'WR'
    #         if self.site == 'NFL'
    #             return 'http://fantasy.nfl.com/league/' + self.number.to_s + '/players?_selectedColumnSortOrder_=desc&playerStatus=available&position=3&sort=percentOwned&statCategory=research&statSeason=2016&statWeek=10#playersHomeList=playersHomeList%2C%2Fleague%2F4430415%2Fplayers%253FplayerStatus%253Davailable%2526position%253D3%2526sort%253Dpts%2526statCategory%253Dstats%2526statSeason%253D2016%2526statType%253DfourWeekStats%2Creplace'
    #         elsif self.site == 'ESPN'
    #             return 'http://games.espn.com/ffl/freeagency?leagueId=' + self.number.to_s + '&seasonId=2016#&seasonId=2016&slotCategoryId=4'
    #         elsif self.site =='Yahoo'
    #             return 'https://football.fantasysports.yahoo.com/f1/' + self.number.to_s + '/players?&sort=PR&sdir=1&status=A&pos=WR&stat1=S_S_2016&jsenabled=1'
    #         end
    #     elsif position == 'RB'
    #         if self.site == 'NFL'
    #             return 'http://fantasy.nfl.com/league/' + self.number.to_s + '/players?_selectedColumnSortOrder_=desc&playerStatus=available&position=2&sort=percentOwned&statCategory=research&statSeason=2016&statWeek=10#playersHomeList=playersHomeList%2C%2Fleague%2F4430415%2Fplayers%253FplayerStatus%253Davailable%2526position%253D2%2526sort%253Dpts%2526statCategory%253Dstats%2526statSeason%253D2016%2526statType%253DfourWeekStats%2Creplace'
    #         elsif self.site == 'ESPN'
    #             return 'http://games.espn.com/ffl/freeagency?leagueId=' + self.number.to_s + '&seasonId=2016#&seasonId=2016&slotCategoryId=2'
    #         elsif self.site =='Yahoo'
    #             return 'https://football.fantasysports.yahoo.com/f1/' + self.number.to_s + '/players?&sort=PR&sdir=1&status=A&pos=RB&stat1=S_S_2016&jsenabled=1'
    #         end
    #     elsif position == 'TE'
    #         if self.site == 'NFL'
    #             return 'http://fantasy.nfl.com/league/' + self.number.to_s + '/players?_selectedColumnSortOrder_=desc&playerStatus=available&position=4&sort=percentOwned&statCategory=research&statSeason=2016&statWeek=10#playersHomeList=playersHomeList%2C%2Fleague%2F4430415%2Fplayers%253FplayerStatus%253Davailable%2526position%253D4%2526sort%253Dpts%2526statCategory%253Dstats%2526statSeason%253D2016%2526statType%253DfourWeekStats%2Creplace'
    #         elsif self.site == 'ESPN'
    #             return 'http://games.espn.com/ffl/freeagency?leagueId=' + self.number.to_s + '&seasonId=2016#&seasonId=2016&slotCategoryId=6'
    #         elsif self.site =='Yahoo'
    #             return 'https://football.fantasysports.yahoo.com/f1/' + self.number.to_s + '/players?&sort=PR&sdir=1&status=A&pos=TE&stat1=S_S_2016&jsenabled=1'
    #         end
    #     end
    # end

    # def get_free_agents
    #     team = Team.create(league: self, number: 0)
    #     team.get_free_agents('http://www.cbssports.com/fantasy/football/news/fantasy-football-week-11-rankings-trade-values-chart/',
    #                             self.make_url('QB'),
    #                             self.make_url('WR'),
    #                             self.make_url('RB'),
    #                             self.make_url('TE'))
    # end

end
