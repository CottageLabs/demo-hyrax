class AddIsSystemGeneratedToPermissionTemplateAccesses < ActiveRecord::Migration[6.1]
  def change
    add_column :permission_template_accesses, :is_system_generated, :boolean , default: false
  end
end
