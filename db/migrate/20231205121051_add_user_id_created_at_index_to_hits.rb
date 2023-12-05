class AddUserIdCreatedAtIndexToHits < ActiveRecord::Migration[7.0]
  def change
    add_index :hits, [:user_id, :created_at]
  end
end
