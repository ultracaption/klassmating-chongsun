class CreateTurnouts < ActiveRecord::Migration
  def change
    create_table :turnouts do |t|
      t.integer :time
      t.integer :region_id
      t.integer :count

      t.timestamps
    end
  end
end
