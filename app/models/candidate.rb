class Candidate < ActiveRecord::Base
  belongs_to :district
  belongs_to :party
  has_many :district_votes
end
