class PullRequest < ActiveRecord::Base
  validates :url, presence: true
  validates :reek_smells, numericality: { greater_than_or_equal_to: 0 }
end
