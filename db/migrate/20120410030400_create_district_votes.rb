class CreateDistrictVotes < ActiveRecord::Migration
  def change
    create_table :district_votes do |t|
      t.integer :time
      t.integer :district_id
      t.integer :candidate_id
      t.integer :count

      t.timestamps
    end
  end
end
