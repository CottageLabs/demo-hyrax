class Ability
  include Hydra::Ability

  include Hyrax::Ability
  self.ability_logic += %i[
    everyone_can_create_curation_concerns
  ]

  # Define any customized permissions here.
  def custom_permissions
    return unless current_user.admin?

    can :manage, Role
    can :manage, User
    can :create, [::Dataset]
  end

  def create_content
    return unless current_user
    can [:confirm_delete, :restore], [::Dataset] if current_user.admin?
    can [:create, :tombstone], [::Dataset]
  end

  def can_review_submissions?
    # Short-circuit logic for admins, who should have the ability
    # to review submissions whether or not they are explicitly
    # granted the approving role in any workflows
    return true if admin?

    # Are there any workflows where this user has the "approving" responsibility
    approving_roles = Sipity::Role.where(name: ['approving_publication_manager'])

    return false unless approving_roles
    Hyrax::Workflow::PermissionQuery.scope_processing_agents_for(user: current_user).any? do |agent|
      agent.workflow_responsibilities.joins(:workflow_role).where('sipity_workflow_roles.role_id' => approving_roles.pluck(:id)).any?
    end
  end
end
