class AddAbbreviation < ActiveRecord::Migration
  def change
    add_column :provinces, :abbreviation, :string
    add_column :districts, :abbreviation, :string

  end
end
