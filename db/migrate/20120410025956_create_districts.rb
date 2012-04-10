class CreateDistricts < ActiveRecord::Migration
  def change
    create_table :districts do |t|
      t.integer :province_id
      t.string :name
      t.string :code
      t.integer :total_count
      t.integer :voter_count

      t.timestamps
    end
  end
end
