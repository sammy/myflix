class AddTokenToInvitation < ActiveRecord::Migration
  def change
    add_column :invitations, :token, :string, limit: 255
  end
end
