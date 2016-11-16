class Team < ActiveRecord::Base
    belongs_to :league, inverse_of: :team
    has_and_belongs_to_many :trade, inverse_of: :team
    has_many :player, inverse_of: :team
end