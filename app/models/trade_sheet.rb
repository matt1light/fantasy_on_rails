class TradeSheet < ApplicationRecord
  belongs_to :league
  has_many :trades
end
