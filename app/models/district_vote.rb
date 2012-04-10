class DistrictVote < ActiveRecord::Base
  belongs_to :district
  belongs_to :candidate
end
