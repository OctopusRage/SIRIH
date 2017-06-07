class AddBedsRefToMovements < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key :movements, :beds, :primary_key => "bed_code", :column => "bed_code"
  end
end
