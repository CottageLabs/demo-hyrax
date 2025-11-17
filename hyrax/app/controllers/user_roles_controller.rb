# frozen_string_literal: true

# Controller for managing Roles
class UserRolesController < ApplicationController
  include Hydra::RoleManagement::UserRolesBehavior

  def create
    authorize! :add_user, @role
    user = find_user
    if user
      user.roles << @role
      user.add_workflow_role(@role) if user.save!
  
      redirect_to role_management.role_path(@role)
    else
      redirect_to role_management.role_path(@role),
                  flash: { error: "Invalid user #{params[:user_key]}" }
    end
  end

  def destroy
    authorize! :remove_user, @role
    user = ::User.find(params[:id])
    @role.users.delete(user)

    user.remove_workflow_role(@role) if remove_workflow_roles?(user)

    redirect_to role_management.role_path(@role)
  end

  private

  def remove_workflow_roles?(user)
    user.publication_manager?
  end
end
