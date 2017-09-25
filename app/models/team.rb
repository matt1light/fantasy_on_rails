require 'open-uri'


class Team < ActiveRecord::Base
    belongs_to :league, inverse_of: :team
    has_and_belongs_to_many :trade, inverse_of: :team
    has_many :player, inverse_of: :team

    def make_players(scraped_players, scraped_values)
      scraped_players.select{|p| p[:team] == self.number}.each do |play|
        name = play[:name]
        position = play[:position]
        play_val = scraped_values.select{|p| p[:name] == name} 
        if play_val.length == 0
          Player.create( name: name,
                         team: self,
                         position: position,
                         value: 0)

        elsif play_val.length == 1
          value = play_val.first[:value]
          Player.create( name: name,
                         team: self,
                         position: position,
                         value: value)
        else
          puts 'There is more than one player with that name and position'
        end
      end
      self.set_starters
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
