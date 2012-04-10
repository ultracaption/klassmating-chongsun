class AddProvinceIdToTurnout < ActiveRecord::Migration
  def change
    add_column :turnouts, :province_id, :integer

  end
end
