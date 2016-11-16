require 'open-uri'
class Team < ActiveRecord::Base
    belongs_to :league, inverse_of: :team
    has_and_belongs_to_many :trade, inverse_of: :team
    has_many :player, inverse_of: :team
    

    def make_url
        if self.league.site == 'NFL'
            puts 'http://canada.fantasy.nfl.com/league/' + self.league.number.to_s + '/team/' + self.number.to_s
            return 'http://canada.fantasy.nfl.com/league/' + self.league.number.to_s + '/team/' + self.number.to_s
        elsif self.league.site == 'ESPN'
            return 'http://games.espn.com/ffl/clubhouse?leagueId=' + self.league.number.to_s + '8&teamId=' + self.number.to_s
        elsif self.league.site == 'Yahoo'
            return 'https://football.fantasysports.yahoo.com/f1/' + self.league.number.to_s + '/' + self.number.to_s
        end
    end
    
    def get_team
        doc = Nokogiri::HTML(open(self.make_url))
        if self.league.site == 'NFL'
            puts self.league.site
            playerNames = doc.xpath("//a[contains(@class, 'playerName')]")
            puts 'here'
            for name in playerNames do
                position = name.next_element().text[0..1]
                Player.create(name: name.text, position: position, team: self)
            end
        elsif self.league.site == 'ESPN'
            playerNames = doc.xpath("//*(@class='flexpop')")
            for name in playerNames do
                position = name.next().text[-3..-1]
                Player.create(name: name, position: position, team: self)
            end
        elsif self.league.site == 'yahoo'
            playerNames = doc.xpath("//*(@class='Nowrap name F-link')")
            for name in playerNames do
                position = name.next_element().text[-3..-1]
                Player.create(name: name, position: position, team: self)
            end
        end
    end  
    
    def get_values
        doc = Nokogiri::HTML(open('http://www.cbssports.com/fantasy/football/news/fantasy-football-week-11-rankings-trade-values-chart/'))
        players = Player.where(team: self)
        players.each do |t|
            name = t.name
            path = doc.xpath("//td[text()[contains(., '#{name}')]]")
            puts path[0]
            # if path
            #     t.value = path.next_element.text
            #     print t.value
            # end
        end
    end
        
        
    
end