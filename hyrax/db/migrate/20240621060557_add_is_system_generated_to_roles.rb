class AddIsSystemGeneratedToRoles < ActiveRecord::Migration[6.1]
  def change
    add_column :roles, :is_system_generated, :boolean, default: false
  end
end
