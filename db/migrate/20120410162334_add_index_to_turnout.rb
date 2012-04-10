class AddIndexToTurnout < ActiveRecord::Migration
  def change
    add_column :turnouts, :index, :integer
    remove_column :turnouts, :count
    add_column :turnouts, :rate, :float

  end
end
