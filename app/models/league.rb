class League < ActiveRecord::Base
    has_many :team, inverse_of: :league
    has_many :players
end
