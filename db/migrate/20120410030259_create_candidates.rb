class CreateCandidates < ActiveRecord::Migration
  def change
    create_table :candidates do |t|
      t.integer :district_id
      t.integer :party_id
      t.integer :number
      t.string :name
      t.string :photo_url

      t.timestamps
    end
  end
end
