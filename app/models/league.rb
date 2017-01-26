class League < ActiveRecord::Base
    has_many :team, inverse_of: :league
    has_many :players

    def make_url(position)
        if position == 'QB'
            if self.site == 'NFL'
                return 'http://fantasy.nfl.com/league/' + self.number.to_s + '/players?playerStatus=available&position=1&statCategory=stats&statSeason=2016&statType=fourWeekStats&statWeek=10#playersHomeList=playersHomeList%2C%2Fleague%2F4430415%2Fplayers%253FplayerStatus%253Davailable%2526position%253D1%2526sort%253Dpts%2526statCategory%253Dstats%2526statSeason%253D2016%2526statType%253DfourWeekStats%2Creplace'
            elsif self.site == 'ESPN'
                return 'http://games.espn.com/ffl/freeagency?leagueId=' + self.number.to_s + '&seasonId=2016#&seasonId=2016&slotCategoryId=0'
            elsif self.site =='Yahoo'
                return 'https://football.fantasysports.yahoo.com/f1/' + self.number.to_s + '/players?&sort=PR&sdir=1&status=A&pos=QB&stat1=S_S_2016&jsenabled=1'
            end
        elsif position == 'WR'
            if self.site == 'NFL'
                return 'http://fantasy.nfl.com/league/' + self.number.to_s + '/players?_selectedColumnSortOrder_=desc&playerStatus=available&position=3&sort=percentOwned&statCategory=research&statSeason=2016&statWeek=10#playersHomeList=playersHomeList%2C%2Fleague%2F4430415%2Fplayers%253FplayerStatus%253Davailable%2526position%253D3%2526sort%253Dpts%2526statCategory%253Dstats%2526statSeason%253D2016%2526statType%253DfourWeekStats%2Creplace'
            elsif self.site == 'ESPN'
                return 'http://games.espn.com/ffl/freeagency?leagueId=' + self.number.to_s + '&seasonId=2016#&seasonId=2016&slotCategoryId=4'
            elsif self.site =='Yahoo'
                return 'https://football.fantasysports.yahoo.com/f1/' + self.number.to_s + '/players?&sort=PR&sdir=1&status=A&pos=WR&stat1=S_S_2016&jsenabled=1'
            end
        elsif position == 'RB'
            if self.site == 'NFL'
                return 'http://fantasy.nfl.com/league/' + self.number.to_s + '/players?_selectedColumnSortOrder_=desc&playerStatus=available&position=2&sort=percentOwned&statCategory=research&statSeason=2016&statWeek=10#playersHomeList=playersHomeList%2C%2Fleague%2F4430415%2Fplayers%253FplayerStatus%253Davailable%2526position%253D2%2526sort%253Dpts%2526statCategory%253Dstats%2526statSeason%253D2016%2526statType%253DfourWeekStats%2Creplace'
            elsif self.site == 'ESPN'
                return 'http://games.espn.com/ffl/freeagency?leagueId=' + self.number.to_s + '&seasonId=2016#&seasonId=2016&slotCategoryId=2'
            elsif self.site =='Yahoo'
                return 'https://football.fantasysports.yahoo.com/f1/' + self.number.to_s + '/players?&sort=PR&sdir=1&status=A&pos=RB&stat1=S_S_2016&jsenabled=1'
            end
        elsif position == 'TE'
            if self.site == 'NFL'
                return 'http://fantasy.nfl.com/league/' + self.number.to_s + '/players?_selectedColumnSortOrder_=desc&playerStatus=available&position=4&sort=percentOwned&statCategory=research&statSeason=2016&statWeek=10#playersHomeList=playersHomeList%2C%2Fleague%2F4430415%2Fplayers%253FplayerStatus%253Davailable%2526position%253D4%2526sort%253Dpts%2526statCategory%253Dstats%2526statSeason%253D2016%2526statType%253DfourWeekStats%2Creplace'
            elsif self.site == 'ESPN'
                return 'http://games.espn.com/ffl/freeagency?leagueId=' + self.number.to_s + '&seasonId=2016#&seasonId=2016&slotCategoryId=6'
            elsif self.site =='Yahoo'
                return 'https://football.fantasysports.yahoo.com/f1/' + self.number.to_s + '/players?&sort=PR&sdir=1&status=A&pos=TE&stat1=S_S_2016&jsenabled=1'
            end
        end
    end

    def get_free_agents
        team = Team.create(league: self, number: 0)
        team.get_free_agents('http://www.cbssports.com/fantasy/football/news/fantasy-football-week-11-rankings-trade-values-chart/',
                                self.make_url('QB'),
                                self.make_url('WR'),
                                self.make_url('RB'),
                                self.make_url('TE'))
    end

    def get_all_teams
        (1..self.size).each do |t|
            unless t == 2
                team = Team.create(league: self, number: t)
                team.get_team
                team.get_values
                team.set_starters
            end
        end
    end

    def import_league
        self.get_free_agents
        self.get_all_teams
        (1..self.size).each do |t|
            unless t == 2
                Team.find_by(league: self, number: t).normalize_values
            end
        end
    end
end
