class AddVerifiedToGroups < ActiveRecord::Migration[7.0]
  def change
    add_column :groups, :verified, :boolean
  end
end
