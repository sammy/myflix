class CreateRelationship < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :user_id
      t.integer :follower_id
    end
  end
end
