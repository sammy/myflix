class RenameUserIdInRelationships < ActiveRecord::Migration
  def change
    rename_column :relationships, :user_id, :leader_id
  end
end
