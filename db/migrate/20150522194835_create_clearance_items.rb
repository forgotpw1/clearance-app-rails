class CreateClearanceItems < ActiveRecord::Migration
  def change
    create_table :clearance_items do |t|
      t.integer :clearance_batch_id
      t.integer :item_id

      t.timestamps null: false
    end
  end
end
