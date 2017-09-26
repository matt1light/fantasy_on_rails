class Trade < ActiveRecord::Base
    belongs_to :league, inverse_of: :trade
    has_and_belongs_to_many :team, inverse_of: :trade
    has_and_belongs_to_many :player, inverse_of: :trade


    def get_players
      self.player
    end

    def total_value
      self.value_1 + self.value_2
    end

    def value_1
      self.my_value
    end

    def value_2
      self.other_value
    end
end
