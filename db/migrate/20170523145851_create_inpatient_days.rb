class CreateInpatientDays < ActiveRecord::Migration[5.1]
  def change
    create_table :inpatient_days do |t|
      t.date :period
      t.integer :total

      t.timestamps
    end
    add_index :inpatient_days, :period, unique: true
  end
end
