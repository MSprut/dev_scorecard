class Contributor < ApplicationRecord

  belongs_to :repo
  has_many :pull_statistics
end
