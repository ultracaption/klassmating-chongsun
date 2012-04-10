class PartyVote < ActiveRecord::Base
  belongs_to :region
  belongs_to :district
end
