class AddTimestampsToRelationships < ActiveRecord::Migration
  def change
    add_column :relationships, :created_at, :datetime
    add_column :relationships, :updated_at, :datetime
  end
end
