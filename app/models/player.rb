class Player < ActiveRecord::Base
    belongs_to :team, inverse_of: :player
    has_and_belongs_to_many :trade, inverse_of: :player

    def open_reddit
        Launchy.open('https://www.reddit.com/r/fantasyfootball/search?q=' + 
                     self[:name].gsub(' ', '+') +
                     '&restrict_sr=on&t=week')
    end

    def has_replacement?
      self.find_replacement.present?
    end

    def find_replacement
      free_agent_team = Team.where(number: 0).first
      Player.where(team: free_agent_team, position: self.position).select{|p| p.value > self.value}
    end
end
