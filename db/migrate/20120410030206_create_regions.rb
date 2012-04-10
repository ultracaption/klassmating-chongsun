class CreateRegions < ActiveRecord::Migration
  def change
    create_table :regions do |t|
      t.integer :province_id
      t.string :name
      t.integer :total_count
      t.integer :voter_count

      t.timestamps
    end
  end
end
