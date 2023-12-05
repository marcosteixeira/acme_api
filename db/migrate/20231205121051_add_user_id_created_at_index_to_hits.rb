# frozen_string_literal: true

class AddUserIdCreatedAtIndexToHits < ActiveRecord::Migration[7.0]
  def change
    add_index :hits, %i[user_id created_at]
  end
end
