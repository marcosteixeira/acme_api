class RemoveUserIdIndexFromHits < ActiveRecord::Migration[7.0]
  def change
    remove_index :hits, :user_id
  end
end
