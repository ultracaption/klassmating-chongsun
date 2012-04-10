class CreateDivisions < ActiveRecord::Migration
  def change
    create_table :divisions do |t|
      t.integer :region_id
      t.integer :district_id

      t.timestamps
    end
  end
end
