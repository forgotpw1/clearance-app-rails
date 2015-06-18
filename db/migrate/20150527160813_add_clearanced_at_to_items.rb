class AddClearancedAtToItems < ActiveRecord::Migration
  def change
    add_column :items, :clearanced_at, :datetime, default: nil
  end
end
