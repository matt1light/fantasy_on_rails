class Player < ActiveRecord::Base
    belongs_to :team, inverse_of: :player
    has_and_belongs_to_many :trade, inverse_of: :player
end