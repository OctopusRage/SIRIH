class ChangeRoomIdToRoomCode < ActiveRecord::Migration[5.1]
  def change
    rename_column :movements, :bed_id, :bed_code
  end
end
