require 'open-uri'
class Team < ActiveRecord::Base
    belongs_to :league, inverse_of: :team
    has_and_belongs_to_many :trade, inverse_of: :team
    has_many :player, inverse_of: :team


    def make_url
        if self.league.site == 'NFL'
            return 'http://canada.fantasy.nfl.com/league/' +
                    self.league.number.to_s +
                    '/team/' +
                    self.number.to_s
        elsif self.league.site == 'ESPN'
            return 'http://games.espn.com/ffl/clubhouse?leagueId=' +
                    self.league.number.to_s +
                    '8&teamId=' +
                    self.number.to_s
        elsif self.league.site == 'Yahoo'
            return 'https://football.fantasysports.yahoo.com/f1/' +
            self.league.number.to_s +
            '/' +
            self.number.to_s
        end
    end

    def get_team
        doc = Nokogiri::HTML(open(self.make_url))
        if self.league.site == 'NFL'
            playerNames = doc.xpath("//a[contains(@class, 'playerName')]")
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
############### TODO fix this so it works for fucking leveon bell
    def get_values
        doc = Nokogiri::HTML(open('http://www.cbssports.com/fantasy/football/news/fantasy-football-week-11-rankings-trade-values-chart/'))
        players = Player.where(team: self)
        players.each do |t|
            name = t.name
            unless name == "Le\'Veon Bell"
                path = doc.xpath("//td[text()[contains(., '#{name}')]]")[0]
            else
                path = doc.xpath("//td[text()[contains(., 'Le\'Veon Bell')]]")[0]
            end
            if path
                puts path.next.next.text
                t.update(value: path.next.next.text)
            end
        end
    end

    def set_starters
        players = Player.where(team: self).order(value: :desc)
        qb = wr = rb = te = flex = 0
        players.each do |t|
            if t.position == 'QB' && qb == 0
                qb += 1
                t.update(starter: true)
            elsif t.position == 'WR' && wr<2
                wr += 1
                t.update(starter: true)
            elsif t.position == 'RB' && rb<2
                rb += 1
                t.update(starter: true)
            elsif t.position == 'TE' && te == 0
                te += 1
                t.update(starter: true)
            elsif t.position == ('RB'||'WR') && flex == 0
                flex += 1
                t.update(starter: true)
            end
        end
    end

    def get_starters_total
        players = Player.where(team: self, starter: true)
        total = 0
        players.each do |t|
            total += t.value
        end
        return total
    end

############# NORMALIZE VALUES

    def normalize_values
        players = Player.where(team: self)
        players.each do |t|
            if t.position == ('QB'||'WR'||'RB'||'TE')
                free_value = Player.find_by(team: Team.find_by(number: 0), position: t.position).value
                old_value = (t.value?  ? t.value : 0)
                new_value = old_value - free_value
                t.update(value: new_value)
            end
        end
    end


############## FREE AGENCY
    def get_replacement(position, url, names)
        doc = Nokogiri::HTML(open(url))
        if self.league.site == 'NFL'
            freeAgents = doc.xpath("//a[contains(@class, 'playerName')]")
        end
        names.each do |f|
            freeAgents.each do |g|
                if g.text == f
                    Player.create(name: f, team: self, position: position)
                    return
                end
            end
        end
    end

    def get_free_agents(valueUrl, qbUrl, wrUrl, rbUrl, teUrl)
        cbs = Nokogiri::HTML(open(valueUrl)).xpath("//td")
        playerNames = []
        cbs.each do |t|
            if t.text.match(/\s+(\w+\s\w+),\s\w+\s+/)
                playerNames.push(t.text.match(/\s+(\w+\s\w+),\s\w+\s+/)[1])
            end
        end
        self.get_replacement('QB', qbUrl, playerNames)
        self.get_replacement('WR', wrUrl, playerNames)
        self.get_replacement('RB', rbUrl, playerNames)
        self.get_replacement('TE', teUrl, playerNames)
        self.get_values
    end



end
