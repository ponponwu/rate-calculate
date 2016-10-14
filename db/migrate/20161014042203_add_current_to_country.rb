class AddCurrentToCountry < ActiveRecord::Migration
  def change
    add_column :countries, :rate_array, :string
  end
end
