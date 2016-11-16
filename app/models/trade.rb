class Trade < ActiveRecord::Base
    belongs_to :league, inverse_of: :trade
    has_and_belongs_to_many :team, inverse_of: :trade
    has_and_belongs_to_many :player, inverse_of: :trade
end
