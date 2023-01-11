class AddPersonalGroupToUsers < ActiveRecord::Migration[7.0]
  def change
    User.all.each { |user| user.create_personal_group unless user.exists_personal_group? }
  end
end
