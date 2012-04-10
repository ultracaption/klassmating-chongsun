class CreatePartyVotes < ActiveRecord::Migration
  def change
    create_table :party_votes do |t|
      t.integer :time
      t.integer :region_id
      t.integer :party_id
      t.integer :count

      t.timestamps
    end
  end
end
