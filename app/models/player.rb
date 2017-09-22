class Player < ActiveRecord::Base
    belongs_to :team, inverse_of: :player
    has_and_belongs_to_many :trade, inverse_of: :player

    def open_reddit
        Launchy.open('https://www.reddit.com/r/fantasyfootball/search?q=' + 
                     self[:name].gsub(' ', '+') +
                     '&restrict_sr=on&t=week')
    end
end
