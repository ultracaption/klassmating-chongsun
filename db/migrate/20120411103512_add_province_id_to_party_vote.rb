class AddProvinceIdToPartyVote < ActiveRecord::Migration
  def change
    add_column :party_votes, :province_id, :integer

  end
end
