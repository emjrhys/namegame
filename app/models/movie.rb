class Movie < ApplicationRecord
  validates :title, :id, :cast, presence: true
  serialize :cast
  self.primary_key = :id
end
