class AddEntryStatusToMovements < ActiveRecord::Migration[5.1]
  def change
    add_column :movements, :entry_status, :integer, :null => true
  end
end
