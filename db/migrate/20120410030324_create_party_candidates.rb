class CreatePartyCandidates < ActiveRecord::Migration
  def change
    create_table :party_candidates do |t|
      t.integer :party_id
      t.integer :number
      t.string :name
      t.string :photo_url

      t.timestamps
    end
  end
end
