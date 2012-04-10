class Party < ActiveRecord::Base
  has_many :candidates
  has_many :party_candidates
  has_many :party_votes
end
