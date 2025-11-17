module AppRoles
  extend ActiveSupport::Concern

  def publication_manager?
    roles.exists?(name: "publication_manager")
  end

  def admin?
    roles.exists?(name: "admin")
  end

  private

  def has_role?(role_name)
    roles.exists?({ role_name => true })
  end
end
