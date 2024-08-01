class RemoveColumnWeekdayFromMerchant < ActiveRecord::Migration[7.1]
  def up
    remove_column :merchants, :weekday
  end

  def down
    add_column :merchants, :weekday, :integer
  end
end
